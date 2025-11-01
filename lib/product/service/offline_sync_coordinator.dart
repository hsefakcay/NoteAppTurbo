import 'dart:async';

import '../models/note.dart';
import '../models/sync_operation.dart';
import 'connectivity_service.dart';
import 'note_service.dart';
import 'sync_queue_service.dart';

/// Offline sync stratejisini koordine eden servis
/// Single Responsibility: Sync logic ve strateji yönetimi
class OfflineSyncCoordinator {
  OfflineSyncCoordinator({
    required NoteService noteService,
    required SyncQueueService syncQueue,
    required ConnectivityService connectivity,
  }) : _noteService = noteService,
       _syncQueue = syncQueue,
       _connectivity = connectivity;

  final NoteService _noteService;
  final SyncQueueService _syncQueue;
  final ConnectivityService _connectivity;

  /// Create işlemi - Optimistic sync stratejisi
  Future<CreateResult> createNote({
    required Note localNote,
    required String title,
    required String content,
    required bool pinned,
  }) async {
    // Her zaman backend'e göndermeyi dene (Optimistic)
    try {
      final serverNote = await _noteService.createNote(
        title: title,
        content: content,
        pinned: pinned,
      );
      return CreateResult.success(serverNote);
    } catch (e) {
      // Başarısız: Connectivity güncelle (fire-and-forget) ve kuyruğa ekle
      unawaited(_connectivity.checkConnectivity());
      await _enqueueCreate(localNote);
      return CreateResult.queued(localNote);
    }
  }

  /// Update işlemi - Optimistic sync stratejisi
  Future<SyncStatus> updateNote(Note note) async {
    try {
      await _noteService.updateNote(note);
      return SyncStatus.synced;
    } catch (e) {
      unawaited(_connectivity.checkConnectivity());
      await _enqueueUpdate(note);
      return SyncStatus.queued;
    }
  }

  /// Delete işlemi - Optimistic sync stratejisi
  Future<SyncStatus> deleteNote(Note note) async {
    try {
      await _noteService.deleteNote(note.id);
      return SyncStatus.synced;
    } catch (e) {
      unawaited(_connectivity.checkConnectivity());
      await _enqueueDelete(note.id);
      return SyncStatus.queued;
    }
  }

  /// TogglePin işlemi - Optimistic sync stratejisi
  Future<SyncStatus> togglePin(String noteId, bool pinned) async {
    try {
      await _noteService.togglePin(noteId, pinned);
      return SyncStatus.synced;
    } catch (e) {
      unawaited(_connectivity.checkConnectivity());
      await _enqueueTogglePin(noteId, pinned);
      return SyncStatus.queued;
    }
  }

  /// Tüm kuyruktaki işlemleri senkronize et
  Future<SyncResult> syncAll() async {
    return _syncQueue.syncAll();
  }

  /// Bekleyen işlem sayısı
  int get pendingCount => _syncQueue.pendingOperationsCount;

  /// Bekleyen işlem var mı?
  bool get hasPending => _syncQueue.hasPendingOperations;

  // Private enqueue methodları
  Future<void> _enqueueCreate(Note note) async {
    await _syncQueue.enqueue(
      SyncOperation(
        id: '${note.id}_create',
        type: SyncOperationType.create,
        noteId: note.id,
        timestamp: DateTime.now(),
        noteData: note.toJson(),
      ),
    );
  }

  Future<void> _enqueueUpdate(Note note) async {
    await _syncQueue.enqueue(
      SyncOperation(
        id: '${note.id}_update_${DateTime.now().millisecondsSinceEpoch}',
        type: SyncOperationType.update,
        noteId: note.id,
        timestamp: DateTime.now(),
        noteData: note.toJson(),
      ),
    );
  }

  Future<void> _enqueueDelete(String noteId) async {
    await _syncQueue.enqueue(
      SyncOperation(
        id: '${noteId}_delete_${DateTime.now().millisecondsSinceEpoch}',
        type: SyncOperationType.delete,
        noteId: noteId,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _enqueueTogglePin(String noteId, bool pinned) async {
    await _syncQueue.enqueue(
      SyncOperation(
        id: '${noteId}_pin_${DateTime.now().millisecondsSinceEpoch}',
        type: SyncOperationType.togglePin,
        noteId: noteId,
        timestamp: DateTime.now(),
        isPinned: pinned,
      ),
    );
  }
}

/// Sync durumu
enum SyncStatus {
  synced, // Backend'e başarıyla gönderildi
  queued, // Kuyruğa eklendi
}

/// Create işlemi sonucu
class CreateResult {
  const CreateResult({required this.note, required this.status});

  factory CreateResult.success(Note serverNote) {
    return CreateResult(note: serverNote, status: SyncStatus.synced);
  }

  factory CreateResult.queued(Note localNote) {
    return CreateResult(note: localNote, status: SyncStatus.queued);
  }

  final Note note;
  final SyncStatus status;

  bool get isSynced => status == SyncStatus.synced;
  bool get isQueued => status == SyncStatus.queued;
}
