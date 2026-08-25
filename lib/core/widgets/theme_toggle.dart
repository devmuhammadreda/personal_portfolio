import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme_mode.dart';
import '../theme/theme_cubit.dart';

/// Animated three-way switch (light / gold / dark) with a sliding knob
/// and crossfading icons.
final class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  static const Map<AppThemeMode, AlignmentDirectional> _knobAlignment = {
    AppThemeMode.light: AlignmentDirectional.centerStart,
    AppThemeMode.gold: AlignmentDirectional.center,
    AppThemeMode.dark: AlignmentDirectional.centerEnd,
  };

  static const Map<AppThemeMode, IconData> _icons = {
    AppThemeMode.light: Icons.light_mode_rounded,
    AppThemeMode.gold: Icons.workspace_premium_rounded,
    AppThemeMode.dark: Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, mode) {
        final LinearGradient? knobGradient = switch (mode) {
          AppThemeMode.dark => const LinearGradient(
            colors: [
              AppPalette.brandIndigo,
              AppPalette.brandViolet,
            ],
          ),
          AppThemeMode.gold => const LinearGradient(
            colors: [AppPalette.brandBronze, AppPalette.brandGold],
          ),
          AppThemeMode.light => null,
        };
        return GestureDetector(
          onTap: () => context.read<ThemeCubit>().toggle(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 88,
            height: 32,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: scheme.surfaceContainerHighest,
              border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  alignment: _knobAlignment[mode]!,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: knobGradient,
                      color: knobGradient == null ? scheme.primary : null,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Icon(
                        _icons[mode],
                        key: ValueKey<AppThemeMode>(mode),
                        size: 15,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
