import 'package:flutter/material.dart';

/// Yakında gelecek özellikler için dialog
class ComingSoonDialog {
  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yakında'),
        content: const Text('Bu özellik yakında eklenecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam')),
        ],
      ),
    );
  }
}
