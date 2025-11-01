import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../product/widgets/custom_text_field.dart';

/// Not başlık alanı widget'ı
class NoteTitleField extends StatelessWidget {
  const NoteTitleField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'note.title'.tr(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          hintText: 'note.titleHint'.tr(),
          prefixIcon: Icons.title_rounded,
          validator: (v) => (v == null || v.isEmpty) ? 'note.title'.tr() : null,
        ),
      ],
    );
  }
}

