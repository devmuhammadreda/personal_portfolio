import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/responsive.dart';
import '../../../portfolio/domain/entities/project_category.dart';
import '../../../portfolio/domain/repositories/project_repository.dart';
import '../../../portfolio/domain/entities/project.dart';
import '../cubit/dashboard_cubit.dart';

final class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(getIt<ProjectRepository>())..load(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          switch (state.status) {
            case DashboardStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case DashboardStatus.failure:
              return _ErrorPane(
                message: state.errorMessage,
                onRetry: () => context.read<DashboardCubit>().load(),
              );
            case DashboardStatus.ready:
              return _DashboardBody(state: state);
          }
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.isCompact;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    icon: Icons.folder_open_rounded,
                    label: 'Total projects',
                    value: '${state.totalProjects}',
                    color: theme.colorScheme.primary,
                  ),
                  _StatCard(
                    icon: Icons.star_rounded,
                    label: 'Featured',
                    value: '${state.featuredCount}',
                    color: Colors.amber.shade700,
                  ),
                  for (final entry in state.categoryCounts.entries)
                    _StatCard(
                      icon: switch (entry.key) {
                        ProjectCategory.mobile => Icons.phone_iphone_rounded,
                        ProjectCategory.web => Icons.web_rounded,
                        ProjectCategory.fullstack => Icons.dns_rounded,
                      },
                      label: entry.key.label,
                      value: '${entry.value}',
                      color: theme.colorScheme.secondary,
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recently updated',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.go(AppRoutes.adminNewProject),
                    icon: const Icon(Icons.add_rounded, size: 19),
                    label: const Text('New project'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.recentProjects.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Icon(
                          Icons.rocket_launch_outlined,
                          size: 38,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No projects yet. Add your first one!',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < state.recentProjects.length; i++) ...[
                        if (i > 0) Divider(height: 1),
                        _RecentTile(project: state.recentProjects[i]),
                      ],
                    ],
                  ),
                ),
              if (!isCompact) const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 190,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: theme.textTheme.headlineMedium),
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: project.imageUrls.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                project.imageUrls.first,
                width: 54,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image_outlined),
              ),
            )
          : const Icon(Icons.image_outlined),
      title: Text(project.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${project.category.label} · updated ${_dateText(project.updatedAt)}',
      ),
      trailing: project.featured
          ? Icon(Icons.star_rounded, color: Colors.amber.shade600)
          : null,
      onTap: () => context.go('/admin/projects/${project.id}'),
    );
  }

  String _dateText(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ErrorPane extends StatelessWidget {
  const _ErrorPane({this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 42),
          const SizedBox(height: 12),
          Text(message ?? 'Failed to load.', textAlign: TextAlign.center),
          const SizedBox(height: 14),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
