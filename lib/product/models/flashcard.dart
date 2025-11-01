import 'package:equatable/equatable.dart';

/// Flashcard model
class Flashcard extends Equatable {
  const Flashcard({required this.question, required this.answer});

  final String question;
  final String answer;

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(question: json['question'] as String, answer: json['answer'] as String);
  }

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer};

  @override
  List<Object?> get props => [question, answer];
}

/// Flashcard generation request
class FlashcardRequest {
  const FlashcardRequest({required this.noteContent});

  final String noteContent;

  Map<String, dynamic> toJson() => {'note_content': noteContent};
}

/// Flashcard generation response
class FlashcardResponse {
  const FlashcardResponse({required this.flashcards, required this.noteContentPreview});

  final List<Flashcard> flashcards;
  final String noteContentPreview;

  factory FlashcardResponse.fromJson(Map<String, dynamic> json) {
    return FlashcardResponse(
      flashcards: (json['flashcards'] as List<dynamic>)
          .map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
          .toList(),
      noteContentPreview: json['note_content_preview'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'flashcards': flashcards.map((e) => e.toJson()).toList(),
    'note_content_preview': noteContentPreview,
  };
}
