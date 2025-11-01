import 'package:flutter/material.dart';

/// Bottom sheet üst çubuğu (drag handle)
class NoteBottomSheetDragHandle extends StatelessWidget {
  const NoteBottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
