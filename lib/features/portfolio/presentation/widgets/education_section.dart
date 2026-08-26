import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../domain/entities/education.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'scroll_reveal.dart';
import 'section_header.dart';
import 'section_timeline.dart';

final class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) =>
          previous.educations != current.educations,
      builder: (context, state) {
        final educations = state.educations;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              index: '03',
              title: context.loc.educationSectionTitle,
            ),
            const SizedBox(height: 28),
            if (educations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    context.loc.educationEmptyPublic,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              SectionTimeline(
                children: [
                  for (var i = 0; i < educations.length; i++)
                    ScrollReveal.child(
                      key: ValueKey<String>(
                        'edu-${educations[i].institution}-$i',
                      ),
                      delay: Duration(milliseconds: (i * 90).clamp(0, 450)),
                      child: _EducationCard(education: educations[i]),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final String grade = education.grade ?? '';

    return TimelineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  education.degree,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TimelinePeriodBadge(
                start: education.startDate,
                end: education.endDate,
                yearOnly: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            grade.isEmpty
                ? '${education.institution} · ${education.fieldOfStudy}'
                : '${education.institution} · ${education.fieldOfStudy} · $grade',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
