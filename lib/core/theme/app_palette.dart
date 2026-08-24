import 'package:flutter/material.dart';

abstract final class AppPalette {
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color brandViolet = Color(0xFF8B5CF6);
  static const Color brandCyan = Color(0xFF22D3EE);

  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF273244);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEF2F7);
  static const Color lightBorder = Color(0xFFDDE4EC);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF52607A);

  static const List<Color> heroGradient = [brandIndigo, brandViolet, brandCyan];

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [brandIndigo, brandViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ColorScheme colorScheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: isDark ? const Color(0xFF818CF8) : brandIndigo,
      onPrimary:
          isDark ? const Color(0xFF0A0E1A) : Colors.white,
      primaryContainer: isDark ? darkSurfaceVariant : const Color(0xFFE0E7FF),
      onPrimaryContainer: isDark ? darkTextPrimary : const Color(0xFF1E1B4B),
      secondary: brandCyan,
      onSecondary: const Color(0xFF04252B),
      secondaryContainer:
          isDark ? darkSurfaceVariant : const Color(0xFFCFFAFE),
      onSecondaryContainer: isDark ? darkTextPrimary : const Color(0xFF083344),
      error: const Color(0xFFF87171),
      onError: const Color(0xFF450A0A),
      errorContainer: const Color(0xFF7F1D1D),
      onErrorContainer: const Color(0xFFFEE2E2),
      surface: isDark ? darkSurface : lightSurface,
      onSurface: isDark ? darkTextPrimary : lightTextPrimary,
      surfaceContainerHighest:
          isDark ? darkSurfaceVariant : lightSurfaceVariant,
      onSurfaceVariant: isDark ? darkTextSecondary : lightTextSecondary,
      outline: isDark ? darkBorder : lightBorder,
      outlineVariant: isDark ? darkBorder : lightBorder,
      shadow: Colors.black,
      scrim: Colors.black54,
    );
  }
}
