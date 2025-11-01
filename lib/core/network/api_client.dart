import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _resolveBaseUrl(),
          // Offline-first için kısa timeout (cache zaten anında gösteriliyor)
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 5),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;
          final token = await user?.getIdToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          final prefix = dotenv.maybeGet('API_PATH_PREFIX');
          if (prefix != null && prefix.isNotEmpty) {
            // Tek bir slash ile birleştir
            final normalized = _normalizePath(prefix);
            if (!options.path.startsWith(normalized)) {
              options.path = '$normalized${options.path}';
            }
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Zaman aşımı ve ağ hatalarını daha anlaşılır kıl
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            error = DioException(
              requestOptions: error.requestOptions,
              type: error.type,
              error:
                  'İstek zaman aşımına uğradı. Sunucuya erişilemiyor olabilir: ${_resolveBaseUrl()}',
            );
            return handler.next(error);
          }

          // 401 ise token'ı yenileyip bir kez yeniden dene
          final response = error.response;
          if (response?.statusCode == 401) {
            final original = error.requestOptions;
            final alreadyRetried = original.extra['__retried401__'] == true;
            final user = FirebaseAuth.instance.currentUser;
            if (!alreadyRetried && user != null) {
              try {
                final freshToken = await user.getIdToken(true);
                if (freshToken != null) {
                  _logTokenClaimsForDebug(freshToken);
                }
                final opts = Options(
                  method: original.method,
                  headers: {
                    ...original.headers,
                    if (freshToken != null) 'Authorization': 'Bearer $freshToken',
                  },
                );
                final newReq = await _dio.request<dynamic>(
                  original.path,
                  data: original.data,
                  queryParameters: original.queryParameters,
                  options: opts.copyWith(extra: {...original.extra, '__retried401__': true}),
                );
                return handler.resolve(newReq);
              } catch (_) {
                // Yenileme başarısızsa orijinal hatayı ilet
              }
            }

            // Yenileme yapılmadıysa/başarısızsa mevcut header'daki token claim'lerini logla
            final auth = original.headers['Authorization'] as String?;
            final token = auth?.startsWith('Bearer ') == true ? auth!.substring(7) : null;
            if (token != null) {
              _logTokenClaimsForDebug(token);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;

  Dio get client => _dio;

  static String _resolveBaseUrl() {
    final fromEnv = dotenv.maybeGet('API_BASE_URL');
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }
    // Platforma göre emülatör/cihaz varsayılanları
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android Emulator -> host makine
    }
    // iOS Simulator/macOS/Windows/Linux için localhost uygundur
    return 'http://127.0.0.1:8000';
  }

  static String _normalizePath(String p) {
    var path = p.trim();
    if (!path.startsWith('/')) path = '/$path';
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);
    return path;
  }

  static void _logTokenClaimsForDebug(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return;
      String normalized(String input) {
        var out = input.replaceAll('-', '+').replaceAll('_', '/');
        while (out.length % 4 != 0) {
          out += '=';
        }
        return out;
      }

      final payload =
          json.decode(utf8.decode(base64Url.decode(normalized(parts[1])))) as Map<String, dynamic>;
      final iss = payload['iss'];
      final aud = payload['aud'];
      final sub = payload['sub'];
      final exp = payload['exp'];
    } catch (_) {
      // ignore: avoid_print
      print('[Auth Debug] token claims parse failed');
    }
  }
}
