import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/admin/auth/presentation/cubit/auth_cubit.dart';
import 'core/di/injector.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

class PersonalPortfolioApp extends StatelessWidget {
  const PersonalPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App-scope cubits: theme + auth bridge to the router guard.
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Flutter Developer — Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: getIt<GoRouter>(),
          );
        },
      ),
    );
  }
}
