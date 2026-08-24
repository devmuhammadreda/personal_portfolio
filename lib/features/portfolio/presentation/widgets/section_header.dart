import 'package:flutter/material.dart';

final class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.index, required this.title});

  final String index;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          index,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(width: 16),
        Expanded(child: Divider(color: theme.colorScheme.outline)),
      ],
    );
  }
}
