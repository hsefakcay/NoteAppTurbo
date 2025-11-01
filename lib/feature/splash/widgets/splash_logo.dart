import 'package:flutter/material.dart';

/// Splash ekranı logo widget'ı
///
/// Animasyonlu logo gösterir - Reusable component
class SplashLogo extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const SplashLogo({
    super.key,
    this.size = 120,
    this.iconSize = 60,
    this.backgroundColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.note_alt_outlined, size: iconSize, color: iconColor),
    );
  }
}
