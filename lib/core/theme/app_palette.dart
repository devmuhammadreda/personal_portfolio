import 'package:flutter/material.dart';

import 'app_theme_mode.dart';

abstract final class AppPalette {
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color brandViolet = Color(0xFF8B5CF6);
  static const Color brandCyan = Color(0xFF22D3EE);

  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandBronze = Color(0xFFB8860B);
  static const Color brandChampagne = Color(0xFFE8C468);

  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF273244);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEF2F7);
  static const Color lightBorder = Color(0xFFDDE4EC);

  static const Color goldBackground = Color(0xFFFBF7EC);
  static const Color goldSurface = Color(0xFFFFFCF4);
  static const Color goldSurfaceVariant = Color(0xFFF2EBDA);
  static const Color goldBorder = Color(0xFFE3D9C0);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF52607A);

  static const Color goldTextPrimary = Color(0xFF2B2113);
  static const Color goldTextSecondary = Color(0xFF7D6E52);

  static Color background(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkBackground,
    AppThemeMode.light => lightBackground,
    AppThemeMode.gold => goldBackground,
  };

  static Color surface(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkSurface,
    AppThemeMode.light => lightSurface,
    AppThemeMode.gold => goldSurface,
  };

  static Color surfaceVariant(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkSurfaceVariant,
    AppThemeMode.light => lightSurfaceVariant,
    AppThemeMode.gold => goldSurfaceVariant,
  };

  static Color textPrimary(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkTextPrimary,
    AppThemeMode.light => lightTextPrimary,
    AppThemeMode.gold => goldTextPrimary,
  };

  static Color textSecondary(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkTextSecondary,
    AppThemeMode.light => lightTextSecondary,
    AppThemeMode.gold => goldTextSecondary,
  };

  static Color border(AppThemeMode mode) => switch (mode) {
    AppThemeMode.dark => darkBorder,
    AppThemeMode.light => lightBorder,
    AppThemeMode.gold => goldBorder,
  };

  static ColorScheme colorScheme(AppThemeMode mode) {
    final bool isDark = mode == AppThemeMode.dark;

    if (mode == AppThemeMode.gold) {
      return const ColorScheme(
        brightness: Brightness.light,
        primary: brandBronze,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFF5E7C3),
        onPrimaryContainer: Color(0xFF3F2E04),
        secondary: Color(0xFFA16207),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFFAEDD3),
        onSecondaryContainer: Color(0xFF42330A),
        error: Color(0xFFF87171),
        onError: Color(0xFF450A0A),
        errorContainer: Color(0xFF7F1D1D),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: goldSurface,
        onSurface: goldTextPrimary,
        surfaceContainerHighest: goldSurfaceVariant,
        onSurfaceVariant: goldTextSecondary,
        outline: goldBorder,
        outlineVariant: goldBorder,
        shadow: Colors.black,
        scrim: Colors.black54,
      );
    }

    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? const Color(0xFF818CF8) : brandIndigo,
      onPrimary: isDark ? const Color(0xFF0A0E1A) : Colors.white,
      primaryContainer: isDark ? darkSurfaceVariant : const Color(0xFFE0E7FF),
      onPrimaryContainer: isDark ? darkTextPrimary : const Color(0xFF1E1B4B),
      secondary: brandCyan,
      onSecondary: const Color(0xFF04252B),
      secondaryContainer: isDark ? darkSurfaceVariant : const Color(0xFFCFFAFE),
      onSecondaryContainer: isDark ? darkTextPrimary : const Color(0xFF083344),
      error: const Color(0xFFF87171),
      onError: const Color(0xFF450A0A),
      errorContainer: const Color(0xFF7F1D1D),
      onErrorContainer: const Color(0xFFFEE2E2),
      surface: surface(mode),
      onSurface: textPrimary(mode),
      surfaceContainerHighest: surfaceVariant(mode),
      onSurfaceVariant: textSecondary(mode),
      outline: border(mode),
      outlineVariant: border(mode),
      shadow: Colors.black,
      scrim: Colors.black54,
    );
  }
}
