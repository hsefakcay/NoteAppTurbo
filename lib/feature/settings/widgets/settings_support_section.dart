import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'settings_menu_item.dart';
import 'settings_section.dart';

/// Destek bölümü
class SettingsSupportSection extends StatelessWidget {
  const SettingsSupportSection({
    super.key,
    required this.onContactSupport,
    required this.onGoToWebsite,
  });

  final VoidCallback onContactSupport;
  final VoidCallback onGoToWebsite;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'settings.support'.tr(),
      children: [
        SettingsMenuItem(
          icon: Icons.support_agent_outlined,
          title: 'settings.contactSupport'.tr(),
          onTap: onContactSupport,
        ),
        SettingsMenuItem(icon: Icons.language, title: 'settings.goToWebsite'.tr(), onTap: onGoToWebsite),
      ],
    );
  }
}
