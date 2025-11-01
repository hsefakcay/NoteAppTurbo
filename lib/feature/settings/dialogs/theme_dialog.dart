import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';

/// Tema seçim dialogu
class ThemeDialog {
  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tema Seç'),
        content: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Açık'),
                  value: ThemeMode.light,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemeMode(value);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Koyu'),
                  value: ThemeMode.dark,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemeMode(value);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Sistem'),
                  value: ThemeMode.system,
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemeMode(value);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
