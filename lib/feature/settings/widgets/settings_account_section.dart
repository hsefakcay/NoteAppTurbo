import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_cubit.dart';
import 'settings_menu_item.dart';
import 'settings_section.dart';

/// Hesap ayarları bölümü
class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({
    super.key,
    required this.onLanguageChange,
    required this.onThemeChange,
    required this.onFailedUploads,
  });

  final VoidCallback onLanguageChange;
  final VoidCallback onThemeChange;
  final VoidCallback onFailedUploads;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Account',
      children: [
        SettingsMenuItem(icon: Icons.translate, title: 'Change Language', onTap: onLanguageChange),
        SettingsMenuItem(
          icon: Icons.palette_outlined,
          title: 'Theme',
          trailing: _ThemeTrailing(),
          onTap: onThemeChange,
        ),
        SettingsMenuItem(
          icon: Icons.cloud_upload_outlined,
          title: 'Failed Uploads',
          onTap: onFailedUploads,
        ),
      ],
    );
  }
}

/// Tema trailing widget'ı
class _ThemeTrailing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        String themeName;
        switch (state.themeMode) {
          case ThemeMode.light:
            themeName = 'Light';
            break;
          case ThemeMode.dark:
            themeName = 'Dark';
            break;
          case ThemeMode.system:
            themeName = 'System';
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            themeName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }
}
