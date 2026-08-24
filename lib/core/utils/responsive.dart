import 'package:flutter/material.dart';

abstract final class Breakpoints {
  static const double tablet = 720;
  static const double desktop = 1120;
}

enum WindowSize { mobile, tablet, desktop }

extension ResponsiveContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  WindowSize get windowSize {
    final double width = screenSize.width;
    if (width < Breakpoints.tablet) return WindowSize.mobile;
    if (width < Breakpoints.desktop) return WindowSize.tablet;
    return WindowSize.desktop;
  }

  bool get isMobile => windowSize == WindowSize.mobile;

  bool get isTablet => windowSize == WindowSize.tablet;

  bool get isDesktop => windowSize == WindowSize.desktop;

  bool get isCompact => windowSize != WindowSize.desktop;

  /// Max content width for centered page sections.
  double get contentMaxWidth => switch (windowSize) {
    WindowSize.mobile => screenSize.width * 0.92,
    WindowSize.tablet => 680,
    WindowSize.desktop => 1140,
  };

  EdgeInsets get sectionPadding => switch (windowSize) {
    WindowSize.mobile => const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 64,
    ),
    WindowSize.tablet => const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 88,
    ),
    WindowSize.desktop => const EdgeInsets.symmetric(
      horizontal: 48,
      vertical: 110,
    ),
  };
}
