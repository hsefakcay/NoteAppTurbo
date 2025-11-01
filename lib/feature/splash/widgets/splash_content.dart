import 'package:flutter/material.dart';

import 'splash_logo.dart';

/// Splash ekranı içerik widget'ı
///
/// Logo, başlık ve loading indicator'ı içerir
class SplashContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashContent({super.key, required this.fadeAnimation, required this.scaleAnimation});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fadeAnimation.value,
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const SplashLogo(),
            const SizedBox(height: 24),

            // App ismi
            const Text(
              'Note App Turbo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
