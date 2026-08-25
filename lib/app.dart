import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;

import 'core/di/injector.dart';
import 'core/localizations_cubit/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/theme_cubit.dart';
import 'l10n/app_localizations.dart';

/// Root widget shared by both flavors.
///
/// Flavor entry points inject their own extra providers (e.g. the admin
/// [BlocProvider]) and title; everything else — theming, localization,
/// router config and the flavor banner — is handled here.
class PersonalPortfolioApp extends StatelessWidget {
  const PersonalPortfolioApp({
    super.key,
    this.extraProviders = const <SingleChildWidget>[],
    this.title = 'Flutter Developer — Portfolio',
  });

  final List<SingleChildWidget> extraProviders;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App-scope cubits: theme + locale (+ auth in the admin flavor).
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
        ...extraProviders,
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return FlavorBanner(
                child: MaterialApp.router(
                  title: title,
                  debugShowCheckedModeBanner: false,
                  theme:
                      mode == AppThemeMode.gold
                          ? AppTheme.gold
                          : AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode:
                      mode == AppThemeMode.dark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                  locale: locale,
                  supportedLocales: supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routerConfig: getIt<GoRouter>(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
