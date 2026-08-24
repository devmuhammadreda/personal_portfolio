import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';

final class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

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
                    '© $year ${name.isEmpty ? 'Portfolio' : name}. '
                    'Built with Flutter.',
                    style: theme.textTheme.labelMedium,
                  ),
                  InkWell(
                    onTap: () => context.push(AppRoutes.adminLogin),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        'Admin',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.45,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
