import 'package:flutter/material.dart';

/// App-level theme selection.
///
/// [dark] and [light] map 1:1 onto Material's [ThemeMode]; [gold] is a
/// bright, warm-accented variant that rides on [Brightness.light].
enum AppThemeMode {
  dark,
  light,
  gold;

  Brightness get brightness => this == AppThemeMode.dark
      ? Brightness.dark
      : Brightness.light;
}
