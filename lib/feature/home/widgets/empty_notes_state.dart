import 'package:easy_localization/easy_localization.dart';
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
            isSearching ? 'home.notFoundTitle'.tr() : 'home.emptyNotesTitle'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching ? 'home.notFoundMessage'.tr() : 'home.emptyNotesMessage'.tr(),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
