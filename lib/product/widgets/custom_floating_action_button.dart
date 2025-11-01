import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:note_app_turbo/product/constants/app_theme.dart';

/// Modern tasarımlı Floating Action Button
class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    required this.onPressed,
    this.icon = Icons.add,
    this.size = 64.0,
    this.iconSize = 28.0,
    this.tooltip,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final double iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(context.sized.height),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(context.sized.height),
          child: Center(
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
