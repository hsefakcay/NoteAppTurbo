import 'dart:async';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../models/note.dart';
import '../models/sync_operation.dart';
import 'note_service.dart';

/// Offline işlemleri yöneten ve senkronize eden servis
class SyncQueueService {
  SyncQueueService(this._noteService);

  final NoteService _noteService;
  final _syncCompleteController = StreamController<void>.broadcast();

  /// Senkronizasyon tamamlandığında tetiklenir
  Stream<void> get onSyncComplete => _syncCompleteController.stream;

  /// Kuyrukta bekleyen işlem sayısı
  int get pendingOperationsCount {
    final box = Hive.box<SyncOperation>(AppConstants.syncQueueBox);
    return box.length;
  }

  /// Kuyrukta bekleyen işlemler var mı?
  bool get hasPendingOperations => pendingOperationsCount > 0;

  /// İşlemi kuyruğa ekle
  Future<void> enqueue(SyncOperation operation) async {
    final box = Hive.box<SyncOperation>(AppConstants.syncQueueBox);
    await box.put(operation.id, operation);
  }

  /// Tüm bekleyen işlemleri senkronize et
  Future<SyncResult> syncAll() async {
    final box = Hive.box<SyncOperation>(AppConstants.syncQueueBox);
    final operations = box.values.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (operations.isEmpty) {
      return SyncResult.success(0, 0);
    }

    var successCount = 0;
    var failureCount = 0;

    for (final operation in operations) {
      try {
        await _processOperation(operation);
        await box.delete(operation.id);
        successCount++;
      } catch (e) {
        failureCount++;
        // İşlem başarısız oldu, kuyrukta kalsın
      }
    }

    if (successCount > 0) {
      _syncCompleteController.add(null);
    }

    return SyncResult.success(successCount, failureCount);
  }

  /// Tek bir işlemi işle
  Future<void> _processOperation(SyncOperation operation) async {
    switch (operation.type) {
      case SyncOperationType.create:
        await _syncCreate(operation);
        break;
      case SyncOperationType.update:
        await _syncUpdate(operation);
        break;
      case SyncOperationType.delete:
        await _syncDelete(operation);
        break;
      case SyncOperationType.togglePin:
        await _syncTogglePin(operation);
        break;
    }
  }

  /// Create işlemini senkronize et
  Future<void> _syncCreate(SyncOperation operation) async {
    if (operation.noteData == null) return;

    final data = operation.noteData!;
    await _noteService.createNote(
      title: data['title'] as String,
      content: data['content'] as String,
      pinned: data['pinned'] as bool? ?? false,
    );
  }

  /// Update işlemini senkronize et
  Future<void> _syncUpdate(SyncOperation operation) async {
    if (operation.noteData == null) return;

    final note = Note.fromJson(operation.noteData!);
    await _noteService.updateNote(note);
  }

  /// Delete işlemini senkronize et
  Future<void> _syncDelete(SyncOperation operation) async {
    await _noteService.deleteNote(operation.noteId);
  }

  /// TogglePin işlemini senkronize et
  Future<void> _syncTogglePin(SyncOperation operation) async {
    if (operation.isPinned == null) return;

    await _noteService.togglePin(operation.noteId, operation.isPinned!);
  }

  /// Kuyruğu temizle
  Future<void> clearQueue() async {
    final box = Hive.box<SyncOperation>(AppConstants.syncQueueBox);
    await box.clear();
  }

  /// Dispose
  void dispose() {
    _syncCompleteController.close();
  }
}

/// Senkronizasyon sonucu
class SyncResult {
  const SyncResult({required this.successCount, required this.failureCount, this.error});

  factory SyncResult.success(int successCount, int failureCount) {
    return SyncResult(successCount: successCount, failureCount: failureCount);
  }

  factory SyncResult.failure(String error) {
    return SyncResult(successCount: 0, failureCount: 0, error: error);
  }

  final int successCount;
  final int failureCount;
  final String? error;

  bool get hasSuccess => successCount > 0;
  bool get hasFailure => failureCount > 0 || error != null;
  bool get isFullSuccess => successCount > 0 && !hasFailure;
}
