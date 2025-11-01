import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../product/constants/app_constants.dart';
import '../../../product/service/onboarding_service.dart';
import '../../auth/bloc/auth_cubit.dart';

/// Splash ekranı navigasyon logic'ini yöneten mixin
///
/// Bu mixin authentication kontrolü ve yönlendirme işlemlerini yönetir.
/// Best Practice: Navigation logic'i UI'dan ayrılmıştır.
mixin SplashNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Minimum splash görüntüleme süresi (ms)
  static const int _minimumSplashDuration = 3000;

  /// Auth ve onboarding kontrolü yapar, uygun ekrana yönlendirir
  Future<void> checkAuthAndNavigate() async {
    await Future.microtask(() async {
      if (!mounted) return;

      final authCubit = context.read<AuthCubit>();
      final onboardingService = serviceLocator<OnboardingService>();

      // Onboarding durumunu kontrol et
      final hasCompletedOnboarding = onboardingService.hasCompletedOnboarding();

      // Auth durumunu kontrol et
      await authCubit.checkAuth();

      // Minimum splash süresini bekle (UX için)
      await Future.delayed(const Duration(milliseconds: _minimumSplashDuration));

      // Navigasyon işlemi
      if (!mounted) return;
      _navigateToNextScreen(
        isAuthenticated: authCubit.state.isAuthenticated,
        hasCompletedOnboarding: hasCompletedOnboarding,
      );
    });
  }

  /// Kullanıcının auth ve onboarding durumuna göre uygun ekrana yönlendirir
  void _navigateToNextScreen({
    required bool isAuthenticated,
    required bool hasCompletedOnboarding,
  }) {
    if (!mounted) return;

    // Onboarding gösterilmemişse, onboarding'e yönlendir
    if (!hasCompletedOnboarding) {
      Navigator.of(context).pushReplacementNamed(AppConstants.routeOnboarding);
      return;
    }

    // Onboarding tamamlanmışsa, auth durumuna göre yönlendir
    final targetRoute = isAuthenticated ? AppConstants.routeHome : AppConstants.routeLogin;
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }
}
