import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product/constants/app_constants.dart';
import '../../product/models/note.dart';
import '../auth/bloc/auth_cubit.dart';
import 'bloc/notes_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().init();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlar'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthCubit>().signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(AppConstants.routeLogin, (_) => false);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => v.isNotEmpty
                  ? context.read<NotesCubit>().search(v)
                  : context.read<NotesCubit>().clearSearch(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Ara (başlık/içerik)',
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<NotesCubit, NotesState>(
              listener: (context, state) {
                final last = state.lastDeleted;
                if (last != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Silindi: ${last.title}'),
                      action: SnackBarAction(
                        label: 'Geri Al',
                        onPressed: () => context.read<NotesCubit>().restoreLastDeleted(),
                      ),
                    ),
                  );
                }
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
              builder: (context, state) {
                if (state.isLoading && state.notes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notes = state.visible;
                if (notes.isEmpty) {
                  return const Center(child: Text('Henüz not yok'));
                }
                return ListView.separated(
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(note.pinned ? Icons.push_pin : Icons.push_pin_outlined),
                        onPressed: () => context.read<NotesCubit>().updateNote(
                          note.copyWith(pinned: !note.pinned, updatedAt: DateTime.now()),
                        ),
                      ),
                      title: Text(note.title),
                      subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<NotesCubit>().deleteNote(note),
                      ),
                      onTap: () => _openEditDialog(note),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openCreateDialog() async {
    final result = await showDialog<_NoteFormResult>(
      context: context,
      builder: (context) => _NoteDialog(),
    );
    if (result != null) {
      await context.read<NotesCubit>().addNote(result.title, result.content, pinned: result.pinned);
    }
  }

  Future<void> _openEditDialog(Note note) async {
    final result = await showDialog<_NoteFormResult>(
      context: context,
      builder: (context) => _NoteDialog(initial: note),
    );
    if (result != null) {
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
}

class _NoteDialog extends StatefulWidget {
  const _NoteDialog({this.initial});
  final Note? initial;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  bool _pinned = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _pinned = widget.initial?.pinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Yeni Not' : 'Notu Düzenle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) => (v == null || v.isEmpty) ? 'Başlık gerekli' : null,
              ),
              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'İçerik'),
                minLines: 3,
                maxLines: 6,
                validator: (v) => (v == null || v.isEmpty) ? 'İçerik gerekli' : null,
              ),
              SwitchListTile(
                value: _pinned,
                onChanged: (v) => setState(() => _pinned = v),
                title: const Text('Üste Sabitle'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<_NoteFormResult>(null),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(
                _NoteFormResult(
                  title: _titleCtrl.text,
                  content: _contentCtrl.text,
                  pinned: _pinned,
                ),
              );
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _NoteFormResult {
  _NoteFormResult({required this.title, required this.content, required this.pinned});
  final String title;
  final String content;
  final bool pinned;
}
