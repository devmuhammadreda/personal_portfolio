import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localizations_cubit/locale_cubit.dart';

/// Compact EN/ع toggle for the navbar and admin shell.
final class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final bool isArabic = locale.languageCode == 'ar';
        return Tooltip(
          message: isArabic ? 'English' : 'العربية',
          child: InkWell(
            onTap: () => context.read<LocaleCubit>().toggle(),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: scheme.outline.withValues(alpha: .5)),
              ),
              child: Text(
                isArabic ? 'EN' : 'ع',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
