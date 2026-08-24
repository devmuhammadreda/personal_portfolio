import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/project_category.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'project_card.dart';
import 'project_detail_dialog.dart';
import 'scroll_reveal.dart';
import 'section_header.dart';

final class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) =>
          previous.projects != current.projects ||
          previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        final projects = state.filteredProjects;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(index: '02', title: 'Projects'),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _CategoryChip.all(state: state),
                for (final category in ProjectCategory.values)
                  _CategoryChip.category(category: category, state: state),
              ],
            ),
            const SizedBox(height: 26),
            if (projects.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    'No projects here yet — check back soon!',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final int columns = switch (constraints.maxWidth) {
                    final w when w >= 980 => 3,
                    final w when w >= 620 => 2,
                    _ => 1,
                  };
                  return Column(
                    children: [
                      for (
                        var row = 0;
                        row < (projects.length / columns).ceil();
                        row++
                      )
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var col = 0; col < columns; col++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: row * columns + col < projects.length
                                      ? ScrollReveal(
                                          delay: Duration(
                                            milliseconds:
                                                ((row * columns + col) * 90)
                                                    .clamp(0, 450),
                                          ),
                                          builder: (context, revealed) {
                                            final project =
                                                projects[row * columns + col];
                                            return Opacity(
                                              opacity: revealed ? 1 : 0,
                                              child: ProjectCard(
                                                project: project,
                                                onOpen: () => showProjectDetail(
                                                  context,
                                                  project,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                          ],
                        ),
                    ],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

final class _CategoryChip extends StatelessWidget {
  _CategoryChip.category({
    required ProjectCategory this.category,
    required this.state,
  }) : label = category.label,
       isSelected = state.selectedCategory == category;

  _CategoryChip.all({required this.state})
    : label = 'All',
      category = null,
      isSelected = state.selectedCategory == null;

  final String label;
  final ProjectCategory? category;
  final bool isSelected;
  final PortfolioState state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      onSelected: (_) {
        final cubit = context.read<PortfolioCubit>();
        cubit.selectCategory(category);
      },
      selectedColor: scheme.primary.withValues(alpha: 0.18),
      checkmarkColor: scheme.primary,
      showCheckmark: false,
    );
  }
}
