import 'package:flutter/material.dart';

/// Uygulama için tema yapılandırması
class AppTheme {
  // Renkler
  static const Color _primaryLight = Color(0xFF5B8DEF);
  static const Color _primaryDark = Color(0xFF4A7BD9);
  static const Color _backgroundLight = Color(0xFFF5F7FA);
  static const Color _backgroundDark = Color(0xFF1A1A1A);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _surfaceDark = Color(0xFF2D2D2D);
  static const Color _textLight = Color(0xFF1A1A1A);
  static const Color _textDark = Color(0xFFFFFFFF);
  static const Color _textSecondaryLight = Color(0xFF6B7280);
  static const Color _textSecondaryDark = Color(0xFF9CA3AF);

  // Gradient renkler
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B8DEF), Color.fromARGB(255, 89, 172, 249)],
    begin: Alignment.centerLeft,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient darkGradient = primaryGradient;

  /// Açık tema
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        secondary: _primaryLight,
        surface: _surfaceLight,
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textLight,
        onError: Colors.white,
      ),

      // AppBar teması
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _surfaceLight,
        foregroundColor: _textLight,
        titleTextStyle: TextStyle(color: _textLight, fontSize: 20, fontWeight: FontWeight.w600),
      ),

      // Card teması
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _surfaceLight,
      ),

      // Input teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceLight.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        hintStyle: const TextStyle(
          color: _textSecondaryLight,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: _textSecondaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Text teması
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textLight),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _textLight),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _textLight),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: _textLight),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _textLight),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _textSecondaryLight,
        ),
      ),

      // Elevated Button teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button teması
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryLight,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // FloatingActionButton teması
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        iconSize: 32,
        elevation: 6,
      ),
    );
  }

  /// Koyu tema
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        secondary: _primaryDark,
        surface: _surfaceDark,
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textDark,
        onError: Colors.white,
      ),

      // AppBar teması
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _surfaceDark,
        foregroundColor: _textDark,
        titleTextStyle: TextStyle(color: _textDark, fontSize: 20, fontWeight: FontWeight.w600),
      ),

      // Card teması
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _surfaceDark,
      ),

      // Input teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        hintStyle: const TextStyle(
          color: _textSecondaryDark,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: _textSecondaryDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Text teması
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textDark),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _textDark),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _textDark),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: _textDark),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: _textDark),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _textSecondaryDark),
      ),

      // Elevated Button teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button teması
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // FloatingActionButton teması
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
