import 'dart:async';
import 'package:dio/dio.dart';

/// İnternet bağlantısı durumunu kontrol eden servis
class ConnectivityService {
  ConnectivityService(this._dio);

  final Dio _dio;
  final _connectivityController = StreamController<bool>.broadcast();

  /// Bağlantı durumu stream'i
  Stream<bool> get connectivityStream => _connectivityController.stream;

  // Başlangıçta optimistic - ilk kontrolde güncellenecek
  bool _isConnected = true;

  /// Şu anki bağlantı durumu (cache - gerçek durumu garanti etmez)
  bool get isConnected => _isConnected;

  /// İnternet bağlantısını kontrol et
  Future<bool> checkConnectivity() async {
    try {
      final response = await _dio.get<void>(
        '/health',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      _updateConnectivity(response.statusCode == 200);
      return _isConnected;
    } catch (e) {
      _updateConnectivity(false);
      return false;
    }
  }

  /// Bağlantı durumunu güncelle ve broadcast et
  void _updateConnectivity(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectivityController.add(_isConnected);
    }
  }

  /// Periyodik bağlantı kontrolü başlat
  void startPeriodicCheck({Duration interval = const Duration(seconds: 30)}) {
    Timer.periodic(interval, (_) => checkConnectivity());
  }

  /// Dispose
  void dispose() {
    _connectivityController.close();
  }
}
