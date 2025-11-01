part of 'flashcard_cubit.dart';

/// Flashcard state durumları
enum FlashcardStatus { initial, loading, success, error }

/// Flashcard state
class FlashcardState extends Equatable {
  const FlashcardState({
    required this.status,
    this.flashcards,
    this.noteContentPreview,
    this.noteTitle,
    this.errorMessage,
  });

  const FlashcardState.initial()
    : this(
        status: FlashcardStatus.initial,
        flashcards: null,
        noteContentPreview: null,
        noteTitle: null,
        errorMessage: null,
      );

  final FlashcardStatus status;
  final List<Flashcard>? flashcards;
  final String? noteContentPreview;
  final String? noteTitle;
  final String? errorMessage;

  bool get isLoading => status == FlashcardStatus.loading;
  bool get isSuccess => status == FlashcardStatus.success;
  bool get isError => status == FlashcardStatus.error;
  bool get isInitial => status == FlashcardStatus.initial;

  FlashcardState copyWith({
    FlashcardStatus? status,
    List<Flashcard>? flashcards,
    String? noteContentPreview,
    String? noteTitle,
    String? errorMessage,
  }) {
    return FlashcardState(
      status: status ?? this.status,
      flashcards: flashcards ?? this.flashcards,
      noteContentPreview: noteContentPreview ?? this.noteContentPreview,
      noteTitle: noteTitle,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, flashcards, noteContentPreview, noteTitle, errorMessage];
}
