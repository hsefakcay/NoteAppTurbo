import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Ayarlar ekranı başlığı
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.normal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.displayLarge),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 22),
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
