import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

/// Onboarding durumunu yöneten servis
final class OnboardingService {
  OnboardingService();

  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Hive box'ını getirir
  Box<dynamic> get _box => Hive.box<dynamic>(AppConstants.appSettingsBox);

  /// Onboarding'in daha önce gösterilip gösterilmediğini kontrol eder
  bool hasCompletedOnboarding() {
    return _box.get(_onboardingCompletedKey, defaultValue: false) as bool;
  }

  /// Onboarding'in tamamlandığını işaretler
  Future<void> completeOnboarding() async {
    await _box.put(_onboardingCompletedKey, true);
  }

  /// Onboarding durumunu sıfırlar (test için kullanılabilir)
  Future<void> resetOnboarding() async {
    await _box.delete(_onboardingCompletedKey);
  }
}
