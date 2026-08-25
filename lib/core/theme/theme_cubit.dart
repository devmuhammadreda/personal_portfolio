import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_mode.dart';

/// App-scope theme state with light persistence: the selected mode is
/// restored on startup (see [load]) and saved on every change.
class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.dark);

  static const String _prefsKey = 'app_theme_mode';

  /// Restores the persisted mode. No-op when nothing was saved or the
  /// stored value is unknown (e.g. after an enum rename).
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final AppThemeMode? mode = _tryParse(prefs.getString(_prefsKey));
    if (mode != null && mode != state) emit(mode);
  }

  /// Cycles dark → light → gold → dark.
  void toggle() {
    emit(switch (state) {
      AppThemeMode.dark => AppThemeMode.light,
      AppThemeMode.light => AppThemeMode.gold,
      AppThemeMode.gold => AppThemeMode.dark,
    });
    unawaited(_persist());
  }

  void setThemeMode(AppThemeMode mode) {
    if (mode == state) return;
    emit(mode);
    unawaited(_persist());
  }

  Future<void> _persist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, state.name);
  }

  static AppThemeMode? _tryParse(String? value) {
    for (final AppThemeMode mode in AppThemeMode.values) {
      if (mode.name == value) return mode;
    }
    return null;
  }
}
