import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

/// Ayarlar bölümü başlığı
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.sized.normalValue,
            vertical: context.sized.lowValue,
          ),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: context.border.highBorderRadius,
          ),
          child: Column(children: _buildChildrenWithDividers(context)),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(
          Padding(
            padding: EdgeInsets.only(left: context.sized.normalValue * 3.5),
            child: Divider(
              height: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
        );
      }
    }
    return items;
  }
}
