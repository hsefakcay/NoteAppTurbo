import 'package:dio/dio.dart';

import '../models/flashcard.dart';
import '../../core/network/api_client.dart';

/// Flashcard generation service
class FlashcardService {
  FlashcardService(this._apiClient);

  final ApiClient _apiClient;

  /// Generate flashcards from note content
  Future<FlashcardResponse> generateFlashcards(String noteContent) async {
    final Response<Map<String, dynamic>> response = await _apiClient.client
        .post<Map<String, dynamic>>(
          '/flashcards/generate',
          data: FlashcardRequest(noteContent: noteContent).toJson(),
        );
    return FlashcardResponse.fromJson(response.data!);
  }
}
