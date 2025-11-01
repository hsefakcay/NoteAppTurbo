import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../product/models/note.dart';
import '../../core/network/api_client.dart';

class NoteService {
  NoteService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Note>> fetchNotes() async {
    try {
      debugPrint('[NoteService] Fetching notes from: /notes');

      final List<Note> allNotes = [];
      int page = 1;
      const int pageSize = 100; // Backend max 100 destekliyor
      int total = 0;

      // Tüm sayfaları fetch et
      do {
        final Response<Map<String, dynamic>> res = await _apiClient.client
            .get<Map<String, dynamic>>(
              '/notes',
              queryParameters: {'page': page, 'page_size': pageSize},
            );
        debugPrint('[NoteService] Fetch notes response status: ${res.statusCode} (page: $page)');

        final responseData = res.data;
        if (responseData == null) {
          debugPrint('[NoteService] WARNING: Response data is null for page $page');
          break;
        }

        final items = (responseData['items'] as List<dynamic>?) ?? [];
        total = responseData['total'] as int? ?? 0;

        debugPrint('[NoteService] Fetched ${items.length} notes from page $page (total: $total)');

        // Notları parse et ve listeye ekle
        final notes = items.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
        allNotes.addAll(notes);

        // Eğer bu sayfada pageSize'dan az not varsa, son sayfaya ulaştık
        if (items.length < pageSize) {
          break;
        }

        page++;
      } while (allNotes.length < total);

      debugPrint('[NoteService] Total fetched: ${allNotes.length} notes (backend total: $total)');
      return allNotes;
    } catch (e) {
      debugPrint('[NoteService] Error fetching notes: $e');
      rethrow;
    }
  }

  Future<Note> createNote({
    required String title,
    required String content,
    bool pinned = false,
  }) async {
    try {
      debugPrint(
        '[NoteService] Creating note: title=$title, content=${content.substring(0, content.length > 20 ? 20 : content.length)}...',
      );
      final Response<Map<String, dynamic>> res = await _apiClient.client.post<Map<String, dynamic>>(
        '/notes',
        data: {'title': title, 'content': content, 'pinned': pinned},
      );
      debugPrint('[NoteService] Create note response status: ${res.statusCode}');

      if (res.data == null) {
        debugPrint('[NoteService] ERROR: Response data is null');
        throw Exception('Backend\'den yanıt alınamadı. Response data null.');
      }

      debugPrint('[NoteService] Created note with ID: ${res.data!['id']}');
      debugPrint('[NoteService] Response data: ${res.data}');

      try {
        final note = Note.fromJson(res.data!);
        debugPrint('[NoteService] Successfully parsed note: ${note.id}');
        return note;
      } catch (parseError) {
        debugPrint('[NoteService] ERROR parsing note from JSON: $parseError');
        debugPrint('[NoteService] Failed JSON data: ${res.data}');
        rethrow;
      }
    } catch (e) {
      debugPrint('[NoteService] Error creating note: $e');
      if (e is DioException) {
        debugPrint('[NoteService] DioException type: ${e.type}');
        debugPrint('[NoteService] DioException message: ${e.message}');
        debugPrint('[NoteService] Response status: ${e.response?.statusCode}');
        debugPrint('[NoteService] Response data: ${e.response?.data}');
        debugPrint('[NoteService] Request path: ${e.requestOptions.path}');
        debugPrint('[NoteService] Request baseUrl: ${e.requestOptions.baseUrl}');
      }
      rethrow;
    }
  }

  Future<Note> updateNote(Note note) async {
    try {
      debugPrint('[NoteService] Updating note: ${note.id}');
      final Response<Map<String, dynamic>> res = await _apiClient.client.put<Map<String, dynamic>>(
        '/notes/${note.id}',
        data: note.toJson(),
      );
      debugPrint('[NoteService] Update note response status: ${res.statusCode}');
      return Note.fromJson(res.data!);
    } catch (e) {
      debugPrint('[NoteService] Error updating note: $e');
      rethrow;
    }
  }

  Future<Note> togglePin(String noteId, bool pinned) async {
    try {
      debugPrint('[NoteService] Toggling pin for note: $noteId, pinned=$pinned');
      final Response<Map<String, dynamic>> res = await _apiClient.client
          .patch<Map<String, dynamic>>('/notes/$noteId/pin', queryParameters: {'pinned': pinned});
      debugPrint('[NoteService] Toggle pin response status: ${res.statusCode}');
      return Note.fromJson(res.data!);
    } catch (e) {
      debugPrint('[NoteService] Error toggling pin: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      debugPrint('[NoteService] Deleting note: $id');
      await _apiClient.client.delete<void>('/notes/$id');
      debugPrint('[NoteService] Note deleted successfully');
    } catch (e) {
      debugPrint('[NoteService] Error deleting note: $e');
      rethrow;
    }
  }
}
