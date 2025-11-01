import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../product/widgets/custom_text_field.dart';

/// Arama çubuğu ve filtreleme widget'ı
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    this.hasActiveFilter = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;
  final bool hasActiveFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.normal,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField.search(
              controller: controller,
              hintText: 'Notlarda ara...',
              onChanged: onChanged,
              onSuffixIconTap: onClear,
            ),
          ),
          const SizedBox(width: 12),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = hasActiveFilter;

    return Container(
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onFilterTap,
        icon: Icon(
          Icons.filter_list_rounded,
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        tooltip: 'Filtrele',
      ),
    );
  }
}
