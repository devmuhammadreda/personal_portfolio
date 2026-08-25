import 'package:flutter/material.dart';

import '../../../../core/localizations_cubit/category_labels.dart';
import '../../../../core/localizations_cubit/locale_cubit.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/project.dart';

final class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project, required this.onOpen});

  final Project project;
  final VoidCallback onOpen;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedScale(
          scale: _hovering ? 1.02 : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRect(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: _hovering ? 1.08 : 1,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: Image.network(
                            project.imageUrls.isNotEmpty
                                ? project.imageUrls.first
                                : '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: AppPalette.heroGradient
                                        .map(
                                          (color) =>
                                              color.withValues(alpha: 0.25),
                                        )
                                        .toList(),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 42,
                                    color: scheme.primary.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _hovering ? 1 : 0,
                          duration: const Duration(milliseconds: 220),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.visibility_outlined,
                                      size: 17,
                                      color: scheme.onPrimary,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      context.loc.projectCardViewDetails,
                                      style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (project.featured)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Chip(
                              avatar: Icon(
                                Icons.star_rounded,
                                size: 15,
                                color: Colors.amber.shade600,
                              ),
                              label: Text(context.loc.projectCardFeaturedBadge),
                              labelStyle: const TextStyle(fontSize: 11.5),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc
                            .categoryLabel(project.category)
                            .toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.secondary,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tech in project.techStack.take(4))
                            Chip(
                              label: Text(tech),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (project.techStack.length > 4)
                            Chip(
                              label: Text('+${project.techStack.length - 4}'),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
