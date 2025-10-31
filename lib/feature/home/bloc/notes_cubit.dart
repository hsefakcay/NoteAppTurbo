import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kartal/kartal.dart';

import '../../../product/constants/app_constants.dart';
import '../../../product/models/note.dart';
import '../../../product/service/note_service.dart';
import '../../../core/di/service_locator.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesState.initial());

  final NoteService _service = serviceLocator<NoteService>();

  Future<void> init() async {
    await _ensureHive();
    await loadNotes();
  }

  Future<void> _ensureHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NoteAdapter());
    }
    if (!Hive.isBoxOpen(AppConstants.notesBox)) {
      await Hive.openBox<Note>(AppConstants.notesBox);
    }
  }

  Future<void> loadNotes() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      // first try online
      final remote = await _service.fetchNotes();
      await _cacheNotes(remote);
      emit(state.copyWith(isLoading: false, notes: _sorted(remote)));
    } catch (e) {
      // fallback to cache
      final cached = await _getCachedNotes();
      emit(state.copyWith(isLoading: false, notes: _sorted(cached), errorMessage: e.toString()));
    }
  }

  Future<void> addNote(String title, String content, {bool pinned = false}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final created = await _service.createNote(title: title, content: content, pinned: pinned);
      await _upsertCache(created);
      final updated = [...state.notes, created];
      emit(state.copyWith(isLoading: false, notes: _sorted(updated)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateNote(Note note) async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedNote = await _service.updateNote(note);
      await _upsertCache(updatedNote);
      final updatedList = state.notes.map((n) => n.id == updatedNote.id ? updatedNote : n).toList();
      emit(state.copyWith(isLoading: false, notes: _sorted(updatedList)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteNote(Note note) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _service.deleteNote(note.id);
      await _removeFromCache(note.id);
      final updatedList = state.notes.whereNot((n) => n.id == note.id).toList();
      emit(state.copyWith(isLoading: false, notes: _sorted(updatedList), lastDeleted: note));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> restoreLastDeleted() async {
    final note = state.lastDeleted;
    if (note == null) return;
    await addNote(note.title, note.content, pinned: note.pinned);
    emit(state.copyWith(lastDeleted: null));
  }

  void search(String query) {
    final lower = query.toLowerCase();
    final filtered = state.notes
        .where(
          (n) => n.title.toLowerCase().contains(lower) || n.content.toLowerCase().contains(lower),
        )
        .toList();
    emit(state.copyWith(filtered: _sorted(filtered)));
  }

  void clearSearch() => emit(state.copyWith(filtered: null));

  List<Note> _sorted(List<Note> list) {
    final copy = [...list];
    copy.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return copy;
  }

  Future<void> _cacheNotes(List<Note> notes) async {
    final box = Hive.box<Note>(AppConstants.notesBox);
    await box.clear();
    for (final n in notes) {
      await box.put(n.id, n);
    }
  }

  Future<List<Note>> _getCachedNotes() async {
    final box = Hive.box<Note>(AppConstants.notesBox);
    return box.values.toList();
  }

  Future<void> _upsertCache(Note note) async {
    final box = Hive.box<Note>(AppConstants.notesBox);
    await box.put(note.id, note);
  }

  Future<void> _removeFromCache(String id) async {
    final box = Hive.box<Note>(AppConstants.notesBox);
    await box.delete(id);
  }
}
