import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Dil seçim dialogu
class LanguageDialog {
  static void show(BuildContext context) {
    final currentLocale = context.locale;
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
                      Icons.language,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'settings.changeLanguage'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildLanguageOption(
                context: dialogContext,
                theme: theme,
                flag: '🇹🇷',
                title: 'Türkçe',
                subtitle: 'Turkish',
                value: const Locale('tr'),
                groupValue: currentLocale,
                onTap: () {
                  context.setLocale(const Locale('tr'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              const SizedBox(height: 8),
              _buildLanguageOption(
                context: dialogContext,
                theme: theme,
                flag: '🇬🇧',
                title: 'English',
                subtitle: 'English',
                value: const Locale('en'),
                groupValue: currentLocale,
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLanguageOption({
    required BuildContext context,
    required ThemeData theme,
    required String flag,
    required String title,
    required String subtitle,
    required Locale value,
    required Locale groupValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value.languageCode == groupValue.languageCode;
    
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
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected 
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
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

