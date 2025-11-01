import 'package:dio/dio.dart';

import '../../product/models/note.dart';
import '../../core/network/api_client.dart';

class NoteService {
  NoteService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Note>> fetchNotes() async {
    final Response<Map<String, dynamic>> res = await _apiClient.client.get<Map<String, dynamic>>(
      '/notes',
    );
    final items = (res.data?['items'] as List<dynamic>?) ?? [];
    return items.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Note> createNote({
    required String title,
    required String content,
    bool pinned = false,
  }) async {
    final Response<Map<String, dynamic>> res = await _apiClient.client.post<Map<String, dynamic>>(
      '/notes',
      data: {'title': title, 'content': content, 'pinned': pinned},
    );
    return Note.fromJson(res.data!);
  }

  Future<Note> updateNote(Note note) async {
    final Response<Map<String, dynamic>> res = await _apiClient.client.put<Map<String, dynamic>>(
      '/notes/${note.id}',
      data: note.toJson(),
    );
    return Note.fromJson(res.data!);
  }

  Future<Note> togglePin(String noteId, bool pinned) async {
    final Response<Map<String, dynamic>> res = await _apiClient.client.patch<Map<String, dynamic>>(
      '/notes/$noteId/pin',
      queryParameters: {'pinned': pinned},
    );
    return Note.fromJson(res.data!);
  }

  Future<void> deleteNote(String id) async {
    await _apiClient.client.delete<void>('/notes/$id');
  }
}
