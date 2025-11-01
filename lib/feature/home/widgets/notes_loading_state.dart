import 'package:flutter/material.dart';

/// Notlar yüklenirken gösterilen widget
class NotesLoadingState extends StatelessWidget {
  const NotesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('Notlar yükleniyor...', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
