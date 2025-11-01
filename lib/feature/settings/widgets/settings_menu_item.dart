import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Ayarlar menüsü için özelleştirilebilir menü öğesi
class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.padding.normal,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: context.border.normalBorderRadius,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                size: 22,
              ),
            ),
            context.sized.emptySizedWidthBoxNormal,
            Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
            if (trailing != null) trailing!,
            if (trailing == null)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}
