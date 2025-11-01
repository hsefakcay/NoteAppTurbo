import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../../../product/widgets/custom_text_field.dart';

/// Not içerik alanı widget'ı
class NoteContentField extends StatelessWidget {
  const NoteContentField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'note.content'.tr(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        context.sized.emptySizedHeightBoxLow,
        CustomTextField.multiline(
          controller: controller,
          hintText: 'note.contentHint'.tr(),
          minLines: 12,
          maxLines: 12,
          validator: (v) => (v == null || v.isEmpty) ? 'note.content'.tr() : null,
        ),
      ],
    );
  }
}

