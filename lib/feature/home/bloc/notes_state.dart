part of 'notes_cubit.dart';

class NotesState extends Equatable {
  const NotesState({
    required this.isLoading,
    required this.notes,
    this.filtered,
    this.errorMessage,
    this.lastDeleted,
    this.showPinnedOnly = false,
    this.sortBy = NotesSortOption.dateModified,
  });

  const NotesState.initial() : this(isLoading: false, notes: const []);

  final bool isLoading;
  final List<Note> notes;
  final List<Note>? filtered;
  final String? errorMessage;
  final Note? lastDeleted;
  final bool showPinnedOnly;
  final NotesSortOption sortBy;

  List<Note> get visible => filtered ?? notes;

  NotesState copyWith({
    bool? isLoading,
    List<Note>? notes,
    List<Note>? filtered,
    String? errorMessage,
    Note? lastDeleted,
    bool? showPinnedOnly,
    NotesSortOption? sortBy,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      filtered: filtered,
      errorMessage: errorMessage,
      lastDeleted: lastDeleted,
      showPinnedOnly: showPinnedOnly ?? this.showPinnedOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    notes,
    filtered,
    errorMessage,
    lastDeleted?.id,
    showPinnedOnly,
    sortBy,
  ];
}
