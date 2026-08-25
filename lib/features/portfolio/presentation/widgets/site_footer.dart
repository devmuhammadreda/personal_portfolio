import 'package:flutter/material.dart';

import '../../../../core/localizations_cubit/locale_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';

final class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, this.trailing});

  /// Optional widget rendered next to the copyright line (e.g. the
  /// admin-flavor shortcut chip). The public portfolio build passes null.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int year = DateTime.now().year;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) => previous.profile != current.profile,
      builder: (context, state) {
        final String name = state.profile.name;
        return Column(
          children: [
            Divider(color: theme.colorScheme.outline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    context.loc.footerCopyright(
                      year,
                      name.isEmpty ? 'Portfolio' : name,
                    ),
                    style: theme.textTheme.labelMedium,
                  ),
                  ?trailing,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
