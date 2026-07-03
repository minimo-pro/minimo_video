import 'package:flutter/material.dart';

class AppSettingsSection extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const AppSettingsSection({
    super.key,
    required this.title,
    this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 22,
            height: 1,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 7),
          Text(
            description!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.25,
            ),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
