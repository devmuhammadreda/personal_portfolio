import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color primary = isDark
        ? AppPalette.darkTextPrimary
        : AppPalette.lightTextPrimary;
    final Color secondary = isDark
        ? AppPalette.darkTextSecondary
        : AppPalette.lightTextSecondary;

    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          color: primary,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: primary,
          height: 1.15,
        ),
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: primary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: secondary, height: 1.6),
        bodyMedium: TextStyle(fontSize: 14, color: secondary, height: 1.55),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        labelMedium: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: secondary,
        ),
      ),
    );
  }
}
