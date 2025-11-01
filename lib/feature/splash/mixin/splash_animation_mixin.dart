import 'package:flutter/material.dart';

/// Splash ekranı animasyon logic'ini yöneten mixin
///
/// Bu mixin fade ve scale animasyonlarını sağlar.
/// Kullanım: State sınıfına ekleyerek animasyon controller'larına erişim sağlar.
mixin SplashAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  /// Animasyon controller'ına erişim
  AnimationController get animationController => _animationController;

  /// Fade animasyonuna erişim
  Animation<double> get fadeAnimation => _fadeAnimation;

  /// Scale animasyonuna erişim
  Animation<double> get scaleAnimation => _scaleAnimation;

  /// Animasyonları başlatır
  void initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  /// Animasyonları temizler
  void disposeAnimations() {
    _animationController.dispose();
  }
}
