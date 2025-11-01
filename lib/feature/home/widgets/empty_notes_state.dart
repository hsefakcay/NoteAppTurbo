import 'package:flutter/material.dart';

/// Notlar boş olduğunda gösterilen widget
class EmptyNotesState extends StatelessWidget {
  const EmptyNotesState({required this.isSearching, super.key});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Not bulunamadı' : 'Henüz not yok',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching ? 'Farklı bir arama deneyin' : 'Yeni not eklemek için + butonuna tıklayın',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
