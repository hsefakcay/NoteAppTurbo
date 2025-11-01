import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Ayarlar ekranı kullanıcı profil kartı
class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({
    super.key,
    required this.displayName,
    required this.email,
    this.onTap,
  });

  final String displayName;
  final String email;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.border.highBorderRadius,
      child: Container(
        padding: context.padding.normal,
        decoration: BoxDecoration(
          color: context.general.colorScheme.surface,
          borderRadius: context.border.highBorderRadius,
        ),
        child: Row(
          children: [
            // Kullanıcı avatarı (harflerle)
            _buildAvatar(context),
            context.sized.emptySizedWidthBoxNormal,
            // Kullanıcı bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(displayName.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Sağ ok ikonu
            Icon(
              Icons.chevron_right,
              color: context.general.colorScheme.onSurface,
              size: context.sized.dynamicWidth(0.07),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    // İsmin ilk harflerini al
    final initials = _getInitials(displayName);

    return Container(
      width: context.sized.dynamicWidth(0.2),
      height: context.sized.dynamicHeight(0.1),
      decoration: BoxDecoration(
        color: context.general.colorScheme.primary, // Açık mor
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: context.general.colorScheme.onSecondary, // Mor
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length > 2 ? 2 : parts[0].length).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
