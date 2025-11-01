import 'package:easy_localization/easy_localization.dart';
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
      title: 'settings.account'.tr(),
      children: [
        SettingsMenuItem(icon: Icons.translate, title: 'settings.changeLanguage'.tr(), onTap: onLanguageChange),
        SettingsMenuItem(
          icon: Icons.palette_outlined,
          title: 'settings.theme'.tr(),
          trailing: _ThemeTrailing(),
          onTap: onThemeChange,
        ),
        SettingsMenuItem(
          icon: Icons.cloud_upload_outlined,
          title: 'settings.failedUploads'.tr(),
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
            themeName = 'settings.themeLight'.tr();
            break;
          case ThemeMode.dark:
            themeName = 'settings.themeDark'.tr();
            break;
          case ThemeMode.system:
            themeName = 'settings.themeSystem'.tr();
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
