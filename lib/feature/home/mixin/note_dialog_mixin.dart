import 'package:flutter/material.dart';
import '../../../product/models/note.dart';
import '../widgets/note_bottom_sheet.dart';

/// Not bottom sheet işlemleri için mixin
mixin NoteDialogMixin<T extends StatefulWidget> on State<T> {
  /// Yeni not ekleme bottom sheet'ini aç
  Future<NoteFormResult?> openCreateNoteDialog() async {
    return showModalBottomSheet<NoteFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NoteBottomSheet(),
    );
  }

  /// Not düzenleme bottom sheet'ini aç
  Future<NoteFormResult?> openEditNoteDialog(Note note) async {
    return showModalBottomSheet<NoteFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteBottomSheet(initialNote: note),
    );
  }
}
