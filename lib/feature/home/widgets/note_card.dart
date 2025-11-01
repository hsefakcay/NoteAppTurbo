import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../product/models/note.dart';
import '../../../product/utility/extensions/date_extensions.dart';

/// Not kartı widget'ı
class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.onTap,
    required this.onPin,
    required this.onDelete,
    this.onCreateFlashcard,
    super.key,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;
  final VoidCallback? onCreateFlashcard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPinned = note.pinned;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isPinned ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isPinned
                ? theme.colorScheme.primary.withOpacity(0.15)
                : Colors.black.withOpacity(0.06),
            blurRadius: isPinned ? 16 : 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pin ikonu (pinli ise)
                if (isPinned) ...[
                  Icon(Icons.push_pin, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                ],
                // İçerik (sol)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(theme, isPinned),
                      const SizedBox(height: 4),
                      _buildDate(theme),
                    ],
                  ),
                ),
                // Menü (sağ taraf)
                _buildMenu(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Başlık
  Widget _buildTitle(ThemeData theme, bool isPinned) {
    return Text(
      note.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: isPinned ? FontWeight.w600 : FontWeight.normal,
        color: isPinned ? theme.colorScheme.onSurface : null,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Tarih
  Widget _buildDate(ThemeData theme) {
    final isPinned = note.pinned;
    return Text(
      note.updatedAt.toRelativeTime(),
      style: theme.textTheme.bodySmall?.copyWith(
        color: isPinned
            ? theme.colorScheme.onSurface.withOpacity(0.7)
            : theme.colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }

  /// Sağ menü butonu
  Widget _buildMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.6)),
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surface,
      elevation: 8,
      onSelected: (value) {
        switch (value) {
          case 'flashcard':
            onCreateFlashcard?.call();
            break;
          case 'pin':
            onPin();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onCreateFlashcard != null)
          PopupMenuItem(
            value: 'flashcard',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'note.createFlashcard'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'pin',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  note.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  note.pinned ? 'note.unpinNote'.tr() : 'note.pinNote'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'note.delete'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
