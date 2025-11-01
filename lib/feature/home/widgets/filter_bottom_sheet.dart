import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../product/enums/notes_sort_option.dart';

/// Filtreleme seçenekleri için bottom sheet
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    required this.initialShowPinnedOnly,
    required this.initialSortBy,
    super.key,
  });

  final bool initialShowPinnedOnly;
  final NotesSortOption initialSortBy;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late bool _showPinnedOnly;
  late NotesSortOption _sortBy;

  @override
  void initState() {
    super.initState();
    _showPinnedOnly = widget.initialShowPinnedOnly;
    _sortBy = widget.initialSortBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          _buildPinnedFilter(theme),
          const SizedBox(height: 16),
          _buildDivider(theme),
          const SizedBox(height: 16),
          _buildSortOptions(theme),
          const SizedBox(height: 24),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.tune_rounded, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          'filter.title'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPinnedFilter(ThemeData theme) {
    return SwitchListTile(
      value: _showPinnedOnly,
      onChanged: (value) => setState(() => _showPinnedOnly = value),
      title: Text('filter.pinnedOnly'.tr(), style: theme.textTheme.bodyLarge),
      subtitle: Text('filter.pinnedOnlyDescription'.tr(), style: theme.textTheme.bodySmall),
      activeThumbColor: theme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(color: theme.colorScheme.outline.withOpacity(0.2));
  }

  Widget _buildSortOptions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('filter.sorting'.tr(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...NotesSortOption.values.map(
          (option) => RadioListTile<NotesSortOption>(
            value: option,
            groupValue: _sortBy,
            onChanged: (value) => setState(() => _sortBy = value!),
            title: Text(option.label(context)),
            subtitle: Text(option.description(context), style: theme.textTheme.bodySmall),
            activeColor: theme.colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(
                context,
                FilterSettings(showPinnedOnly: false, sortBy: NotesSortOption.dateModified),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('filter.reset'.tr()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                FilterSettings(showPinnedOnly: _showPinnedOnly, sortBy: _sortBy),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('filter.apply'.tr()),
          ),
        ),
      ],
    );
  }
}

/// Filtreleme ayarları
class FilterSettings {
  const FilterSettings({required this.showPinnedOnly, required this.sortBy});

  final bool showPinnedOnly;
  final NotesSortOption sortBy;

  bool get hasActiveFilter => showPinnedOnly || sortBy != NotesSortOption.dateModified;
}
