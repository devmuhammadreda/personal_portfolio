import 'package:flutter/material.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/url_helper.dart';
import '../../domain/entities/project.dart';

/// Modal detail view with an image carousel, full description and links.
Future<void> showProjectDetail(BuildContext context, Project project) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: context.loc.projectDetailsBarrierLabel,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _ProjectDetailDialog(project: project);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _ProjectDetailDialog extends StatefulWidget {
  const _ProjectDetailDialog({required this.project});

  final Project project;

  @override
  State<_ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<_ProjectDetailDialog> {
  int _page = 0;

  Project get project => widget.project;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool isCompact = context.isCompact;
    final double dialogWidth = (MediaQuery.sizeOf(context).width * 0.92).clamp(
      0.0,
      780.0,
    );

    return Dialog(
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ImageCarousel(
                imageUrls: project.imageUrls,
                currentPage: _page,
                onPageChanged: (page) => setState(() => _page = page),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(26, 22, 26, isCompact ? 20 : 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        if (project.featured)
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade600,
                          ),
                        IconButton(
                          tooltip: context.loc.commonClose,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.loc.projectDetailsRole(project.role),
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tech in project.techStack)
                          Chip(
                            label: Text(tech),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      project.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (project.longDescription.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SelectableText(
                        project.longDescription,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        if (project.liveUrl?.isNotEmpty ?? false)
                          FilledButton.icon(
                            onPressed: () => openExternalUrl(project.liveUrl!),
                            icon: const Icon(
                              Icons.open_in_new_rounded,
                              size: 17,
                            ),
                            label: Text(context.loc.projectDetailsLiveDemo),
                          ),
                        if (project.githubUrl?.isNotEmpty ?? false)
                          OutlinedButton.icon(
                            onPressed: () =>
                                openExternalUrl(project.githubUrl!),
                            icon: const Icon(Icons.code_rounded, size: 17),
                            label: Text(context.loc.projectDetailsSourceCode),
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
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({
    required this.imageUrls,
    required this.currentPage,
    required this.onPageChanged,
  });

  final List<String> imageUrls;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (imageUrls.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: scheme.outline,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                maxScale: 3,
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(Icons.broken_image_outlined, size: 42),
                  ),
                ),
              );
            },
          ),
          if (imageUrls.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageUrls.length, (index) {
                  final bool active = index == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? scheme.primary
                          : scheme.onSurface.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
