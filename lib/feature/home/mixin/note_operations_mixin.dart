import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/models/note.dart';
import '../bloc/notes_cubit.dart';
import 'note_dialog_mixin.dart';

/// Not CRUD işlemleri için mixin
mixin NoteOperationsMixin<T extends StatefulWidget> on State<T>, NoteDialogMixin<T> {
  /// Yeni not ekle
  Future<void> createNote() async {
    final result = await openCreateNoteDialog();
    if (result != null && mounted) {
      await context.read<NotesCubit>().addNote(result.title, result.content, pinned: result.pinned);
    }
  }

  /// Notu düzenle
  Future<void> editNote(Note note) async {
    final result = await openEditNoteDialog(note);
    if (result != null && mounted) {
      await context.read<NotesCubit>().updateNote(
        note.copyWith(
          title: result.title,
          content: result.content,
          pinned: result.pinned,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Notu sabitle/sabitlemeyi kaldır
  void toggleNotePin(Note note) {
    context.read<NotesCubit>().toggleNotePin(note);
  }

  /// Notu sil
  void deleteNote(Note note) {
    context.read<NotesCubit>().deleteNote(note);
  }
}
