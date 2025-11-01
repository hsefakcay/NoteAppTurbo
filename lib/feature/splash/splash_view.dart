import 'package:flutter/material.dart';
import '../../product/constants/app_theme.dart';
import 'mixin/splash_animation_mixin.dart';
import 'mixin/splash_navigation_mixin.dart';
import 'widgets/splash_content.dart';

/// Splash ekranı
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin, SplashAnimationMixin, SplashNavigationMixin {
  @override
  void initState() {
    super.initState();
    // Animasyonları başlat
    initializeAnimations();
    // Auth kontrolü ve navigasyon başlat
    checkAuthAndNavigate();
  }

  @override
  void dispose() {
    // Animasyonları temizle
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildGradientBackground(child: _buildAnimatedContent()));
  }

  /// Gradient arkaplan oluşturur
  Widget _buildGradientBackground({required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.primaryGradient,
      ),
      child: Center(child: child),
    );
  }

  /// Animasyonlu içerik oluşturur
  Widget _buildAnimatedContent() {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SplashContent(fadeAnimation: fadeAnimation, scaleAnimation: scaleAnimation);
      },
    );
  }
}
