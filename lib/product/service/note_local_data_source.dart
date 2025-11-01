import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../models/note.dart';

/// Local cache için not repository'si
/// Single Responsibility: Sadece Hive CRUD işlemleri
class NoteLocalDataSource {
  /// Tüm notları cache'den getir
  Future<List<Note>> getAll() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// ID'ye göre not getir
  Future<Note?> getById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  /// Not ekle veya güncelle
  Future<void> upsert(Note note) async {
    final box = await _getBox();
    await box.put(note.id, note);
  }

  /// Birden fazla not ekle veya güncelle
  Future<void> upsertMany(List<Note> notes) async {
    final box = await _getBox();
    final map = {for (final note in notes) note.id: note};
    await box.putAll(map);
  }

  /// Not sil
  Future<void> delete(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// Tüm notları sil
  Future<void> clear() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Tüm notları değiştir (sync sonrası)
  Future<void> replaceAll(List<Note> notes) async {
    final box = await _getBox();
    await box.clear();
    final map = {for (final note in notes) note.id: note};
    await box.putAll(map);
  }

  /// Cache'de kaç not var
  Future<int> count() async {
    final box = await _getBox();
    return box.length;
  }

  /// Cache boş mu?
  Future<bool> isEmpty() async {
    final count = await this.count();
    return count == 0;
  }

  /// Box'ı aç ve getir
  Future<Box<Note>> _getBox() async {
    if (!Hive.isBoxOpen(AppConstants.notesBox)) {
      return Hive.openBox<Note>(AppConstants.notesBox);
    }
    return Hive.box<Note>(AppConstants.notesBox);
  }
}
