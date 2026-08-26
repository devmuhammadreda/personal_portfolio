import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../domain/entities/work_experience.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'scroll_reveal.dart';
import 'section_header.dart';
import 'section_timeline.dart';

final class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) =>
          previous.experiences != current.experiences,
      builder: (context, state) {
        final experiences = state.experiences;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              index: '02',
              title: context.loc.experienceSectionTitle,
            ),
            const SizedBox(height: 28),
            if (experiences.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    context.loc.experienceEmptyPublic,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              SectionTimeline(
                children: [
                  for (var i = 0; i < experiences.length; i++)
                    ScrollReveal.child(
                      key: ValueKey<String>('exp-${experiences[i].company}-$i'),
                      delay: Duration(milliseconds: (i * 90).clamp(0, 450)),
                      child: _ExperienceCard(experience: experiences[i]),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});

  final WorkExperience experience;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final String? location = experience.location;

    return TimelineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  experience.position,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TimelinePeriodBadge(
                start: experience.startDate,
                end: experience.endDate,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            location == null || location.isEmpty
                ? experience.company
                : '${experience.company} · $location',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (experience.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              experience.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
            ),
          ],
        ],
      ),
    );
  }
}
