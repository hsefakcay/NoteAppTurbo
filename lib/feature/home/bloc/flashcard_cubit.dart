import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../product/models/flashcard.dart';
import '../../../../product/service/flashcard_service.dart';

part 'flashcard_state.dart';

/// Flashcard generation Cubit
/// Single Responsibility: Flashcard oluşturma state yönetimi
class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit() : super(const FlashcardState.initial());

  final FlashcardService _flashcardService = serviceLocator<FlashcardService>();

  /// Flashcard oluştur
  Future<void> generateFlashcards(String noteContent, {String? noteTitle}) async {
    if (noteContent.trim().isEmpty) {
      emit(
        state.copyWith(
          status: FlashcardStatus.error,
          errorMessage: 'note.flashcardEmptyError'.tr(),
        ),
      );
      return;
    }

    emit(state.copyWith(status: FlashcardStatus.loading, noteTitle: noteTitle));

    try {
      final response = await _flashcardService.generateFlashcards(noteContent);
      emit(
        state.copyWith(
          status: FlashcardStatus.success,
          flashcards: response.flashcards,
          noteContentPreview: response.noteContentPreview,
          noteTitle: noteTitle,
        ),
      );
    } catch (e) {
      final errorMessage = _parseErrorMessage(e);
      emit(state.copyWith(status: FlashcardStatus.error, errorMessage: errorMessage));
    }
  }

  /// Hata mesajını kullanıcı dostu formata çevir
  String _parseErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Bağlantı zaman aşımına uğradı. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';
        case DioExceptionType.connectionError:
          return 'Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.';
          } else if (statusCode == 500) {
            return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
          } else if (statusCode == 503) {
            return 'Servis şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';
          } else {
            return 'Sunucudan hata alındı. Lütfen tekrar deneyin.';
          }
        case DioExceptionType.cancel:
          return 'İstek iptal edildi.';
        default:
          // Network veya diğer hatalar için genel mesaj
          final errorString = error.error?.toString() ?? error.toString();
          if (errorString.contains('Failed host lookup') ||
              errorString.contains('Connection refused') ||
              errorString.contains('Network is unreachable')) {
            return 'İnternet bağlantınız yok. Lütfen bağlantınızı kontrol edip tekrar deneyin.';
          }
          return 'Flashcard oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.';
      }
    }

    // DioException değilse genel hata mesajı
    final errorString = error.toString();
    if (errorString.contains('timeout') || errorString.contains('Timeout')) {
      return 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.';
    }
    if (errorString.contains('network') || errorString.contains('Network')) {
      return 'İnternet bağlantınız yok. Lütfen bağlantınızı kontrol edin.';
    }

    return 'Flashcard oluşturulurken bir hata oluştu. Lütfen tekrar deneyin.';
  }

  /// State'i sıfırla
  void reset() {
    emit(const FlashcardState.initial());
  }
}
