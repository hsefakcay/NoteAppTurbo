import 'package:flutter/material.dart';

@immutable
class ColorConstants {
  const ColorConstants._();

  // Brand
  static const Color primary = Color(0xFF3F51B5); // Indigo 500
  static const Color primaryDark = Color(0xFF303F9F);
  static const Color secondary = Color(0xFFFFC107); // Amber 500

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textInverse = Colors.white;

  // States
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // Dividers & Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);
}
