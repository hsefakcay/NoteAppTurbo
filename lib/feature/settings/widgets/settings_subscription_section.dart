import 'package:flutter/material.dart';
import 'settings_menu_item.dart';
import 'settings_section.dart';

/// Abonelik ayarları bölümü
class SettingsSubscriptionSection extends StatelessWidget {
  const SettingsSubscriptionSection({
    super.key,
    required this.onCurrentPlan,
    required this.onRestorePurchases,
    required this.onAccessCode,
  });

  final VoidCallback onCurrentPlan;
  final VoidCallback onRestorePurchases;
  final VoidCallback onAccessCode;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Subscription',
      children: [
        SettingsMenuItem(
          icon: Icons.card_membership_outlined,
          title: 'Current Plan',
          trailing: _PlanBadge(),
          onTap: onCurrentPlan,
        ),
        SettingsMenuItem(
          icon: Icons.restore,
          title: 'Restore Purchases',
          onTap: onRestorePurchases,
        ),
        SettingsMenuItem(icon: Icons.vpn_key_outlined, title: 'Access Code', onTap: onAccessCode),
      ],
    );
  }
}

/// Plan badge widget'ı
class _PlanBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
      ),
      child: Text('Free Plan', style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
