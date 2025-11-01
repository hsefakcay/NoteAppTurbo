import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_cubit.dart';

/// Tema değiştirme butonu
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final (icon, tooltip) = _getIconAndTooltip(themeState.themeMode);

        return IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: Icon(icon),
          tooltip: tooltip,
        );
      },
    );
  }

  /// Tema moduna göre ikon ve tooltip döndürür
  (IconData, String) _getIconAndTooltip(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => (Icons.light_mode_outlined, 'Açık Tema'),
      ThemeMode.dark => (Icons.dark_mode_outlined, 'Koyu Tema'),
      ThemeMode.system => (Icons.brightness_auto_outlined, 'Sistem Teması'),
    };
  }
}
