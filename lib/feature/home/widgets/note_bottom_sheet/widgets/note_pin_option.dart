import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Pin seçeneği widget'ı
class NotePinOption extends StatelessWidget {
  const NotePinOption({
    required this.pinned,
    required this.onChanged,
    super.key,
  });

  final bool pinned;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onChanged(!pinned),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: context.padding.normal,
        decoration: BoxDecoration(
          color: pinned
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: pinned
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                pinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: pinned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'note.pinNote'.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: pinned ? theme.colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pinned 
                        ? 'filter.pinnedOnlyDescription'.tr()
                        : 'filter.pinnedOnlyDescription'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: pinned ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                pinned ? Icons.check_circle : Icons.circle_outlined,
                color: pinned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

