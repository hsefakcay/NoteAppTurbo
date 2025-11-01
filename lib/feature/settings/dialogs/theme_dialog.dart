import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';

/// Tema seçim dialogu
class ThemeDialog {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.palette_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'settings.themeSelect'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _buildThemeOption(
                        context: dialogContext,
                        theme: theme,
                        icon: Icons.wb_sunny_outlined,
                        title: 'settings.themeLight'.tr(),
                        value: ThemeMode.light,
                        groupValue: state.themeMode,
                        onTap: () {
                          context.read<ThemeCubit>().setThemeMode(ThemeMode.light);
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildThemeOption(
                        context: dialogContext,
                        theme: theme,
                        icon: Icons.nightlight_round,
                        title: 'settings.themeDark'.tr(),
                        value: ThemeMode.dark,
                        groupValue: state.themeMode,
                        onTap: () {
                          context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildThemeOption(
                        context: dialogContext,
                        theme: theme,
                        icon: Icons.phone_android,
                        title: 'settings.themeSystem'.tr(),
                        value: ThemeMode.system,
                        groupValue: state.themeMode,
                        onTap: () {
                          context.read<ThemeCubit>().setThemeMode(ThemeMode.system);
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildThemeOption({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required ThemeMode value,
    required ThemeMode groupValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primaryContainer.withOpacity(0.5)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected 
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
