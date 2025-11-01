import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/app_constants.dart';
import '../../product/enums/notes_sort_option.dart';
import '../../product/models/note.dart';
import '../../product/widgets/index.dart';
import 'bloc/notes_cubit.dart';
import 'mixin/note_dialog_mixin.dart';
import 'mixin/note_operations_mixin.dart';
import 'mixin/note_snackbar_mixin.dart';
import 'widgets/index.dart';

/// Ana sayfa - Not listesi ve yönetimi
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with NoteDialogMixin, NoteSnackBarMixin, NoteOperationsMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildNotesList()),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: createNote,
        tooltip: 'Yeni Not Ekle',
      ),
    );
  }

  /// AppBar - Başlık ve aksiyonlar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Notes', style: Theme.of(context).textTheme.displayLarge),
      centerTitle: false,
      titleSpacing: 30,
      toolbarHeight: context.sized.highValue,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed(AppConstants.routeSettings),
          icon: const Icon(Icons.settings_outlined, size: 28),
          tooltip: 'Ayarlar',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Arama çubuğu
  Widget _buildSearchBar() {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return SearchBarWidget(
          controller: _searchController,
          onChanged: (query) {
            if (query.isEmpty) {
              context.read<NotesCubit>().clearSearch();
            } else {
              context.read<NotesCubit>().search(query);
            }
          },
          onClear: () {
            _searchController.clear();
            context.read<NotesCubit>().clearSearch();
          },
          onFilterTap: () => _showFilterBottomSheet(context, state),
          hasActiveFilter: state.showPinnedOnly || state.sortBy != NotesSortOption.dateModified,
        );
      },
    );
  }

  /// Filtreleme bottom sheet'ini göster
  Future<void> _showFilterBottomSheet(BuildContext context, NotesState state) async {
    final result = await showModalBottomSheet<FilterSettings>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialShowPinnedOnly: state.showPinnedOnly,
        initialSortBy: state.sortBy,
      ),
    );

    if (result != null && mounted) {
      context.read<NotesCubit>().updateFilters(
        showPinnedOnly: result.showPinnedOnly,
        sortBy: result.sortBy,
      );
    }
  }

  /// Not listesi (BlocConsumer ile state yönetimi)
  Widget _buildNotesList() {
    return BlocConsumer<NotesCubit, NotesState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        if (state.isLoading && state.notes.isEmpty) {
          return const NotesLoadingState();
        }
        if (state.visible.isEmpty) {
          return EmptyNotesState(isSearching: state.filtered != null);
        }
        return ListView.builder(
          padding: context.padding.normal,
          itemCount: state.visible.length,
          itemBuilder: (context, index) => _buildNoteCard(state.visible[index]),
        );
      },
    );
  }

  /// Tek bir not kartı
  Widget _buildNoteCard(Note note) {
    return NoteCard(
      note: note,
      onTap: () => editNote(note),
      onPin: () => toggleNotePin(note),
      onDelete: () => deleteNote(note),
    );
  }

  /// State değişikliklerini dinle
  void _handleStateChanges(BuildContext context, NotesState state) {
    if (state.lastDeleted != null) {
      showDeletedSnackBar(state.lastDeleted!);
    }

    if (state.errorMessage != null) {
      showErrorSnackBar(state.errorMessage!);
    }
  }
}
