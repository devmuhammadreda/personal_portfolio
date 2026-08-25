import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/theme_toggle.dart';

typedef NavTap = void Function();

final class AnimatedNavbar extends StatelessWidget {
  const AnimatedNavbar({
    super.key,
    required this.scrollController,
    required this.title,
    required this.sections,
    required this.onTitleTap,
  });

  final ScrollController scrollController;
  final String title;

  /// (label, onTap) pairs for each site section.
  final List<(String, NavTap)> sections;
  final VoidCallback onTitleTap;

  static const double _expandedHeight = 72;
  static const double _collapsedHeight = 58;
  static const double _blurStartOffset = 40;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = MediaQuery.sizeOf(context).width < 860;
    final ColorScheme scheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final double offset = scrollController.hasClients
            ? scrollController.offset
            : 0;
        final double t = (offset / _blurStartOffset).clamp(0.0, 1.0);
        final double height =
            _expandedHeight - (_expandedHeight - _collapsedHeight) * t;
        final bool blurred = t > 0.5;

        return ClipRect(
          child: BackdropFilter(
            enabled: blurred,
            filter: ImageFilter.blur(sigmaX: 14 * t, sigmaY: 14 * t),
            child: Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: blurred
                    ? theme.scaffoldBackgroundColor.withValues(alpha: 0.78)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.6 * t),
                  ),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: onTitleTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppPalette.accentGradient,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!isCompact)
                    Row(
                      children: [
                        for (var i = 0; i < sections.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _NavButton(
                              label: sections[i].$1,
                              onTap: sections[i].$2,
                            ),
                          ),
                      ],
                    )
                  else
                    IconButton(
                      tooltip: 'Menu',
                      onPressed: () => _showMobileMenu(context),
                      icon: const Icon(Icons.menu_rounded),
                    ),
                  const SizedBox(width: 12),
                  const ThemeToggle(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (label, onTap) in sections)
                ListTile(
                  title: Text(label),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onTap();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({required this.label, required this.onTap});

  final String label;
  final NavTap onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _hovering
                ? scheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
