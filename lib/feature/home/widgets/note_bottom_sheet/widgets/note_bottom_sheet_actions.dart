import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Bottom sheet aksiyon butonları widget'ı
class NoteBottomSheetActions extends StatelessWidget {
  const NoteBottomSheetActions({
    required this.isEditing,
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  final bool isEditing;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.3),
                width: 1.5,
              ),
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: Text(
              'note.cancel'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(
              'note.save'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

