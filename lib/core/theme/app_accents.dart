import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Decorative brand accents exposed through the theme so widgets adapt
/// automatically when the active [AppThemeMode] changes.
@immutable
class AppAccents extends ThemeExtension<AppAccents> {
  const AppAccents({
    required this.heroGradient,
    required this.accentGradient,
    required this.particleColors,
  });

  /// Three-stop gradient used behind hero imagery and fallback tiles.
  final List<Color> heroGradient;

  /// Two-stop gradient for text shaders, rings and icon badges.
  final LinearGradient accentGradient;

  /// Colors cycled by the floating particles background.
  final List<Color> particleColors;

  static const AppAccents violet = AppAccents(
    heroGradient: [AppPalette.brandIndigo, AppPalette.brandViolet, AppPalette.brandCyan],
    accentGradient: LinearGradient(
      colors: [AppPalette.brandIndigo, AppPalette.brandViolet],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    particleColors: [AppPalette.brandIndigo, AppPalette.brandViolet, AppPalette.brandCyan],
  );

  static const AppAccents gold = AppAccents(
    heroGradient: [
      AppPalette.brandBronze,
      AppPalette.brandGold,
      AppPalette.brandChampagne,
    ],
    accentGradient: LinearGradient(
      colors: [AppPalette.brandBronze, AppPalette.brandGold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    particleColors: [
      AppPalette.brandBronze,
      AppPalette.brandGold,
      AppPalette.brandChampagne,
    ],
  );

  @override
  AppAccents copyWith({
    List<Color>? heroGradient,
    LinearGradient? accentGradient,
    List<Color>? particleColors,
  }) {
    return AppAccents(
      heroGradient: heroGradient ?? this.heroGradient,
      accentGradient: accentGradient ?? this.accentGradient,
      particleColors: particleColors ?? this.particleColors,
    );
  }

  @override
  AppAccents lerp(AppAccents? other, double t) {
    if (other == null) return this;
    List<Color> lerpColors(List<Color> a, List<Color> b) => List<Color>.generate(
      a.length,
      (i) => Color.lerp(a[i], b[i], t)!,
    );
    return AppAccents(
      heroGradient: lerpColors(heroGradient, other.heroGradient),
      accentGradient: LinearGradient.lerp(accentGradient, other.accentGradient, t)!,
      particleColors: lerpColors(particleColors, other.particleColors),
    );
  }
}

extension AppAccentsX on BuildContext {
  AppAccents get accents => Theme.of(this).extension<AppAccents>()!;
}
