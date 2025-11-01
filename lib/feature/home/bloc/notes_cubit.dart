import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../core/di/service_locator.dart';
import '../../../product/constants/app_constants.dart';
import '../../../product/enums/notes_sort_option.dart';
import '../../../product/models/note.dart';
import '../../../product/models/sync_operation.dart';
import '../../../product/service/note_local_data_source.dart';
import '../../../product/service/connectivity_service.dart';
import '../../../product/service/note_service.dart';
import '../../../product/service/notes_sort_filter_service.dart';
import '../../../product/service/offline_sync_coordinator.dart';

part 'notes_state.dart';

/// Not yönetimi Cubit (Refactored - Clean & SOLID)
/// Single Responsibility: Sadece state management ve koordinasyon
class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesState.initial());

  // Dependencies
  final NoteService _noteService = serviceLocator<NoteService>();
  final NoteLocalDataSource _repository = serviceLocator<NoteLocalDataSource>();
  final NotesSortFilterService _sortFilter = serviceLocator<NotesSortFilterService>();
  final OfflineSyncCoordinator _syncCoordinator = serviceLocator<OfflineSyncCoordinator>();
  final ConnectivityService _connectivity = serviceLocator<ConnectivityService>();

  StreamSubscription<bool>? _connectivitySubscription;

  /// Init
  Future<void> init() async {
    await _ensureHive();
    _initConnectivityListener(); // Hive açıldıktan SONRA listener başlat
    await _connectivity.checkConnectivity(); // İlk kontrol
    await loadNotes();
    _connectivity.startPeriodicCheck();
  }

  /// Connectivity listener başlat
  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.connectivityStream.listen((isConnected) {
      if (isConnected) {
        _handleConnectionRestored();
      }
    });

    // Sync complete stream'i dinle
    // syncAll() çağırma, sadece result stream'i dinle
    // _syncSubscription kaldırıldı - gerek yok
  }

  /// Bağlantı geri geldiğinde
  Future<void> _handleConnectionRestored() async {
    if (_syncCoordinator.hasPending) {
      await _syncCoordinator.syncAll();
      await loadNotes();
    }
  }

  /// Hive başlat
  Future<void> _ensureHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NoteAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SyncOperationAdapter());
    }

    // Notes box
    if (!Hive.isBoxOpen(AppConstants.notesBox)) {
      try {
        await Hive.openBox<Note>(AppConstants.notesBox);
      } catch (e) {
        // Corrupt box - yeniden oluştur
        await Hive.deleteBoxFromDisk(AppConstants.notesBox);
        await Hive.openBox<Note>(AppConstants.notesBox);
      }
    }

    // Sync queue box
    if (!Hive.isBoxOpen(AppConstants.syncQueueBox)) {
      try {
        await Hive.openBox<SyncOperation>(AppConstants.syncQueueBox);
      } catch (e) {
        // Corrupt box - yeniden oluştur
        await Hive.deleteBoxFromDisk(AppConstants.syncQueueBox);
        await Hive.openBox<SyncOperation>(AppConstants.syncQueueBox);
      }
    }
  }

  /// Notları yükle (Cache-First Strategy)
  Future<void> loadNotes() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // 1. Önce cache'den anında yükle (Instant feedback - ~0.1s)
    final cachedNotes = await _repository.getAll();
    _emitNotes(cachedNotes);

    // 2. Background'da online sync dene
    try {
      final remoteNotes = await _noteService.fetchNotes();
      await _repository.replaceAll(remoteNotes);
      // Online veriler farklıysa güncelle
      _emitNotes(remoteNotes);
    } catch (e) {
      // Online sync başarısız - cache zaten gösterildi
      // Offline mesajı gösterilmiyor (kullanıcı talebi)
      _emitNotes(cachedNotes);
    }
  }

  /// Yeni not ekle (Local-first)
  Future<void> addNote(String title, String content, {bool pinned = false}) async {
    emit(state.copyWith(isLoading: true));

    // Local not oluştur
    final localNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      pinned: pinned,
      updatedAt: DateTime.now(),
    );

    try {
      // Local'e kaydet
      await _repository.upsert(localNote);
      final allNotes = await _repository.getAll();
      _emitNotes(allNotes);

      // Backend'e sync et
      final result = await _syncCoordinator.createNote(
        localNote: localNote,
        title: title,
        content: content,
        pinned: pinned,
      );

      // Backend ID ile güncelle (eğer sync olduysa)
      if (result.isSynced) {
        if (result.note.id != localNote.id) {
          // Server'dan farklı ID geldiyse, local ID'yi sil ve server ID'yi kullan
          await _repository.delete(localNote.id);
          await _repository.upsert(result.note);
        } else {
          // Aynı ID ise (nadir durum), server'dan gelen note'u kullan
          await _repository.upsert(result.note);
        }
        final updatedNotes = await _repository.getAll();
        _emitNotes(updatedNotes);
      }
      // Sync başarılı olsun ya da olmasın, state zaten _emitNotes ile güncelleniyor
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '${'note.errorAdding'.tr()}: ${e.toString()}',
        ),
      );
    }
  }

  /// Notu güncelle (Local-first)
  Future<void> updateNote(Note note) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Local'e kaydet
      await _repository.upsert(note);
      final allNotes = await _repository.getAll();
      _emitNotes(allNotes);

      // Backend'e sync et
      await _syncCoordinator.updateNote(note);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '${'note.errorUpdating'.tr()}: ${e.toString()}',
        ),
      );
    }
  }

  /// Pin durumunu değiştir (Local-first)
  Future<void> toggleNotePin(Note note) async {
    emit(state.copyWith(isLoading: true));

    final updatedNote = note.copyWith(pinned: !note.pinned, updatedAt: DateTime.now());

    try {
      // Local'e kaydet
      await _repository.upsert(updatedNote);
      final allNotes = await _repository.getAll();
      _emitNotes(allNotes);

      // Backend'e sync et
      await _syncCoordinator.togglePin(updatedNote.id, updatedNote.pinned);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '${'note.errorPinning'.tr()}: ${e.toString()}',
        ),
      );
    }
  }

  /// Notu sil (Local-first)
  Future<void> deleteNote(Note note) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Local'den sil
      await _repository.delete(note.id);
      final allNotes = await _repository.getAll();
      _emitNotes(allNotes, lastDeleted: note);

      // Backend'den sil
      await _syncCoordinator.deleteNote(note);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '${'note.errorDeleting'.tr()}: ${e.toString()}',
        ),
      );
    }
  }

  /// Silinen notu geri yükle
  Future<void> restoreLastDeleted() async {
    final note = state.lastDeleted;
    if (note == null) return;
    await addNote(note.title, note.content, pinned: note.pinned);
    emit(state.copyWith(lastDeleted: null));
  }

  /// Arama yap
  void search(String query) {
    final filtered = _sortFilter.apply(
      notes: state.notes,
      showPinnedOnly: state.showPinnedOnly,
      sortBy: state.sortBy,
      searchQuery: query,
    );
    emit(state.copyWith(filtered: filtered));
  }

  /// Aramayı temizle
  void clearSearch() {
    final needsFilter = _sortFilter.needsFiltering(
      showPinnedOnly: state.showPinnedOnly,
      sortBy: state.sortBy,
    );
    emit(state.copyWith(filtered: needsFilter ? _applyCurrentFilters(state.notes) : null));
  }

  /// Filtreleri güncelle
  void updateFilters({bool? showPinnedOnly, NotesSortOption? sortBy}) {
    final newShowPinnedOnly = showPinnedOnly ?? state.showPinnedOnly;
    final newSortBy = sortBy ?? state.sortBy;

    emit(state.copyWith(showPinnedOnly: newShowPinnedOnly, sortBy: newSortBy));

    final needsFilter = _sortFilter.needsFiltering(
      showPinnedOnly: newShowPinnedOnly,
      sortBy: newSortBy,
    );

    if (needsFilter) {
      final filtered = _sortFilter.apply(
        notes: state.notes,
        showPinnedOnly: newShowPinnedOnly,
        sortBy: newSortBy,
      );
      emit(state.copyWith(filtered: filtered));
    } else {
      emit(state.copyWith(filtered: null));
    }
  }

  /// Manuel senkronizasyon - Bekleyen tüm işlemleri sync et
  Future<void> syncAllPending() async {
    if (!_syncCoordinator.hasPending) {
      // Bekleyen işlem yok, state'i güncelle
      emit(state.copyWith(isLoading: false, errorMessage: null));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _syncCoordinator.syncAll();
      await loadNotes(); // Sync sonrası notları yeniden yükle

      if (result.hasFailure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                '${result.successCount} işlem başarılı, ${result.failureCount} işlem başarısız',
          ),
        );
      } else {
        // Başarılı sync - state zaten loadNotes() tarafından güncelleniyor
        emit(state.copyWith(isLoading: false, errorMessage: null));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: '${'note.errorSync'.tr()}: ${e.toString()}'),
      );
      rethrow; // Hatayı yukarı fırlat ki SettingsView'da yakalansın
    }
  }

  /// Mevcut filtreleri uygula
  List<Note> _applyCurrentFilters(List<Note> notes) {
    return _sortFilter.apply(
      notes: notes,
      showPinnedOnly: state.showPinnedOnly,
      sortBy: state.sortBy,
    );
  }

  /// State'e notları emit et
  void _emitNotes(List<Note> notes, {String? errorMessage, Note? lastDeleted}) {
    final sorted = _sortFilter.sortOnly(notes, NotesSortOption.dateModified);

    final needsFilter = _sortFilter.needsFiltering(
      showPinnedOnly: state.showPinnedOnly,
      sortBy: state.sortBy,
    );

    final filtered = needsFilter ? _applyCurrentFilters(sorted) : null;

    emit(
      state.copyWith(
        isLoading: false,
        notes: sorted,
        filtered: filtered,
        errorMessage: errorMessage,
        lastDeleted: lastDeleted,
      ),
    );
  }

  /// Bekleyen sync işlemi var mı?
  bool get hasPendingSync => _syncCoordinator.hasPending;

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
