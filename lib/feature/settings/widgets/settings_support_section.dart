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
      title: 'Support',
      children: [
        SettingsMenuItem(
          icon: Icons.support_agent_outlined,
          title: 'Contact Support',
          onTap: onContactSupport,
        ),
        SettingsMenuItem(icon: Icons.language, title: 'Go to Website', onTap: onGoToWebsite),
      ],
    );
  }
}
