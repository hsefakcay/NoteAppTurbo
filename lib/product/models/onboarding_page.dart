import 'package:flutter/material.dart';

/// Onboarding sayfası modeli
@immutable
final class OnboardingPageModel {
  const OnboardingPageModel({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    this.badgeKey,
    this.color,
  });

  /// Sayfa ikonu
  final IconData icon;

  /// Başlık localization key'i
  final String titleKey;

  /// Açıklama localization key'i
  final String descriptionKey;

  /// Badge metni (opsiyonel, AI-Powered gibi)
  final String? badgeKey;

  /// Özel renk (opsiyonel)
  final Color? color;
}
