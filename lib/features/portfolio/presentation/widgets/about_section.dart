import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/skill.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'scroll_reveal.dart';
import 'section_header.dart';

final class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.isCompact;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) => previous.profile != current.profile,
      builder: (context, state) {
        final profile = state.profile;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(index: '01', title: context.loc.aboutSectionTitle),
            const SizedBox(height: 28),
            Flex(
              direction: isCompact ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isCompact
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ScrollReveal.child(
                    child: SelectableText(
                      profile.aboutMe.isEmpty
                          ? context.loc.aboutBioFallback
                          : profile.aboutMe,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                if (!isCompact) const SizedBox(width: 48),
                Expanded(
                  flex: 2,
                  child: ScrollReveal(
                    delay: const Duration(milliseconds: 150),
                    builder: (context, revealed) => _StatsPanel(
                      yearsOfExperience: profile.yearsOfExperience,
                      projectCount: state.projects.length,
                      techCount: profile.skills.length,
                      revealed: revealed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            Text(
              context.loc.aboutTechHeading,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            _SkillsGrid(skills: profile.skills),
          ],
        );
      },
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({
    required this.yearsOfExperience,
    required this.projectCount,
    required this.techCount,
    required this.revealed,
  });

  final int yearsOfExperience;
  final int projectCount;
  final int techCount;
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.08),
            scheme.secondary.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          _StatTile(
            value: yearsOfExperience,
            label: context.loc.statYearsLabel,
            suffix: '+',
            revealed: revealed,
          ),
          const SizedBox(height: 18),
          _StatTile(
            value: projectCount,
            label: context.loc.statProjectsLabel,
            revealed: revealed,
            delayMs: 120,
          ),
          const SizedBox(height: 18),
          _StatTile(
            value: techCount,
            label: context.loc.statTechnologiesLabel,
            revealed: revealed,
            delayMs: 240,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.revealed,
    this.suffix = '',
    this.delayMs = 0,
  });

  final int value;
  final String label;
  final bool revealed;
  final String suffix;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: theme.textTheme.bodyLarge)),
        const SizedBox(width: 12),
        CountUpText(
          value: value,
          revealed: revealed,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 34,
            foreground: Paint()
              ..shader = AppPalette.accentGradient.createShader(
                const Rect.fromLTWH(0, 0, 120, 40),
              ),
          ),
        ).animate(delay: delayMs.ms).fadeIn(duration: 400.ms),
        if (suffix.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 2),
            child: Text(
              suffix,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({required this.skills});

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (var i = 0; i < skills.length; i++)
          ScrollReveal(
            key: ValueKey<String>('skill-${skills[i].name}-$i'),
            delay: Duration(milliseconds: (i * 60).clamp(0, 480)),
            builder: (context, revealed) => Container(
              width: 220,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          skills[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: revealed ? skills[i].level / 100 : 0,
                        ),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Text(
                            '${(value * 100).round()}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.secondary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: revealed ? skills[i].level / 100 : 0,
                      ),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
