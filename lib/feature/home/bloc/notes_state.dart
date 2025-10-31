part of 'notes_cubit.dart';

class NotesState extends Equatable {
  const NotesState({
    required this.isLoading,
    required this.notes,
    this.filtered,
    this.errorMessage,
    this.lastDeleted,
  });

  const NotesState.initial() : this(isLoading: false, notes: const []);

  final bool isLoading;
  final List<Note> notes;
  final List<Note>? filtered;
  final String? errorMessage;
  final Note? lastDeleted;

  List<Note> get visible => filtered ?? notes;

  NotesState copyWith({
    bool? isLoading,
    List<Note>? notes,
    List<Note>? filtered,
    String? errorMessage,
    Note? lastDeleted,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      filtered: filtered,
      errorMessage: errorMessage,
      lastDeleted: lastDeleted,
    );
  }

  @override
  List<Object?> get props => [isLoading, notes, filtered, errorMessage, lastDeleted?.id];
}
