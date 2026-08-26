import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../core/theme/app_accents.dart';

/// Vertical timeline rail shared by the experience and education sections.
///
/// Children are laid top-to-bottom; every child except the last gets a
/// connector segment drawn between it and the following entry.
final class SectionTimeline extends StatelessWidget {
  const SectionTimeline({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++)
          _TimelineRow(
            isFirst: i == 0,
            isLast: i == children.length - 1,
            child: children[i],
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.isFirst,
    required this.isLast,
    required this.child,
  });

  final bool isFirst;
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                  border: Border.all(color: scheme.outline),
                ),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: context.accents.accentGradient,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: scheme.outline.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: isLast ? 0 : 22),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bordered surface card used for a single timeline entry.
final class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: child,
    );
  }
}

/// Pill showing a localized `MMM yyyy – MMM yyyy` range; a null [end]
/// renders the localized "present" label instead.
final class TimelinePeriodBadge extends StatelessWidget {
  const TimelinePeriodBadge({
    super.key,
    required this.start,
    required this.end,
  });

  final DateTime? start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.primary.withValues(alpha: 0.08),
        border: Border.all(color: scheme.outline),
      ),
      child: Text(
        _periodText(context),
        style: theme.textTheme.labelMedium?.copyWith(
          color: scheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _periodText(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMM(
      Localizations.localeOf(context).toString(),
    );
    final String? startText = start == null ? null : formatter.format(start!);
    final String endText = end == null
        ? context.loc.timelinePresent
        : formatter.format(end!);
    if (startText == null) return endText;
    return '$startText – $endText';
  }
}
