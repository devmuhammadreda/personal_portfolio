import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';

/// Supported app locales; Arabic mirrors the RTL-first audience.
const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

/// App-scope locale state. Starts from the platform locale (when
/// supported) and flips between English/Arabic via [toggle].
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_resolveSystemLocale());

  static Locale _resolveSystemLocale() {
    final Locale platform = PlatformDispatcher.instance.locale;
    final bool supported = supportedLocales.any(
      (locale) => locale.languageCode == platform.languageCode,
    );
    return supported ? Locale(platform.languageCode) : supportedLocales.first;
  }

  bool get isArabic => state.languageCode == 'ar';

  /// Switches between English and Arabic.
  void toggle() => emit(isArabic ? supportedLocales.first : const Locale('ar'));
}

/// Convenience access to the generated localizations:
/// `context.loc.heroGreeting`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
