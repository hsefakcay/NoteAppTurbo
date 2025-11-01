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
    super.key,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
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
                // İçerik (sol)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildTitle(theme), const SizedBox(height: 4), _buildDate(theme)],
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
  Widget _buildTitle(ThemeData theme) {
    return Text(
      note.title,
      style: theme.textTheme.titleMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Tarih
  Widget _buildDate(ThemeData theme) {
    return Text(
      note.updatedAt.toRelativeTime(),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }

  /// Sağ menü butonu
  Widget _buildMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.6)),
      onSelected: (value) {
        switch (value) {
          case 'pin':
            onPin();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'pin',
          child: Row(
            children: [
              Icon(note.pinned ? Icons.push_pin : Icons.push_pin_outlined, size: 20),
              const SizedBox(width: 12),
              Text(note.pinned ? 'Sabitlemeyi Kaldır' : 'Üste Sabitle'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Text('Sil', style: TextStyle(color: theme.colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
