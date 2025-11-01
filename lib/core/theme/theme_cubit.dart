import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Tema durumu - Mevcut tema modunu tutar
class ThemeState {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;
}

/// Tema yönetimi için Cubit
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  static const String _themeBoxName = 'theme_box';
  static const String _themeModeKey = 'theme_mode';

  /// Kaydedilmiş tema tercihini yükle
  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox<String>(_themeBoxName);
      final savedMode = box.get(_themeModeKey);

      if (savedMode != null) {
        final themeMode = _stringToThemeMode(savedMode);
        emit(ThemeState(themeMode));
      }
    } catch (e) {
      // Hata durumunda varsayılan tema kullanılır
      debugPrint('Tema yüklenirken hata: $e');
    }
  }

  /// Tema modunu değiştir ve kaydet
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final box = await Hive.openBox<String>(_themeBoxName);
      await box.put(_themeModeKey, _themeModeToString(mode));
      emit(ThemeState(mode));
    } catch (e) {
      debugPrint('Tema kaydedilirken hata: $e');
    }
  }

  /// Tema modunu döngüsel olarak değiştir: Light -> Dark -> System -> Light
  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    ThemeMode newMode;

    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        newMode = ThemeMode.light;
        break;
    }

    await setThemeMode(newMode);
  }

  /// ThemeMode'u string'e çevir
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// String'i ThemeMode'a çevir
  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
