import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localizations_cubit/category_labels.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../portfolio/domain/entities/project.dart';
import '../../../../portfolio/domain/repositories/project_repository.dart';
import '../cubit/projects_admin_cubit.dart';
import '../cubit/projects_admin_state.dart';

final class ProjectsAdminPage extends StatelessWidget {
  const ProjectsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsAdminCubit>(
      create: (_) => ProjectsAdminCubit(getIt<ProjectRepository>())..load(),
      child: BlocConsumer<ProjectsAdminCubit, ProjectsAdminState>(
        listener: (context, state) {
          final String? error = state.errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error)));
            context.read<ProjectsAdminCubit>().dismissError();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ProjectsAdminStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProjectsAdminStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ??
                          context.loc.projectsAdminFailedToLoad,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.read<ProjectsAdminCubit>().load(),
                      child: Text(context.loc.commonRetry),
                    ),
                  ],
                ),
              );
            case ProjectsAdminStatus.ready:
              return const _ProjectsList();
          }
        },
      ),
    );
  }
}

class _ProjectsList extends StatelessWidget {
  const _ProjectsList();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ProjectsAdminCubit, ProjectsAdminState>(
                      builder: (context, state) => Text(
                        context.loc.projectsAdminCount(state.projects.length),
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.adminNewProject),
                    icon: const Icon(Icons.add_rounded, size: 19),
                    label: Text(context.loc.projectsAdminNew),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                context.loc.projectsAdminReorderHint,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: BlocBuilder<ProjectsAdminCubit, ProjectsAdminState>(
                    builder: (context, state) {
                      if (state.projects.isEmpty) {
                        return Center(
                          child: Text(
                            context.loc.projectsAdminEmpty,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ReorderableListView.builder(
                        buildDefaultDragHandles: true,
                        itemCount: state.projects.length,
                        onReorderItem: (oldIndex, newIndex) => context
                            .read<ProjectsAdminCubit>()
                            .reorder(oldIndex, newIndex),
                        itemBuilder: (context, index) {
                          final project = state.projects[index];
                          final bool busy = state.busyIds.contains(project.id);
                          return _ProjectRow(
                            key: ValueKey(
                              project.id.isEmpty ? 'row-$index' : project.id,
                            ),
                            project: project,
                            busy: busy,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({super.key, required this.project, required this.busy});

  final Project project;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProjectsAdminCubit>();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: !busy,
      leading: project.imageUrls.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                project.imageUrls.first,
                width: 56,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image_outlined),
              ),
            )
          : SizedBox(
              width: 56,
              height: 42,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: theme.colorScheme.outline,
              ),
            ),
      title: Text(
        project.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${context.loc.categoryLabel(project.category)} · '
        '${project.techStack.take(3).join(', ')}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Wrap(
        spacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            tooltip: project.featured
                ? context.loc.tooltipUnfeature
                : context.loc.tooltipFeature,
            onPressed: busy ? null : () => cubit.toggleFeatured(project),
            icon: Icon(
              project.featured
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: project.featured
                  ? Colors.amber.shade600
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            tooltip: context.loc.commonEdit,
            onPressed: () => context.go('/admin/projects/${project.id}'),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: context.loc.commonDelete,
            onPressed: busy ? null : () => _confirmDelete(context, cubit),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.error.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProjectsAdminCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.loc.deleteProjectTitle(project.title)),
          content: Text(context.loc.deleteProjectBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.loc.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.deleteProject(project.id);
              },
              child: Text(context.loc.commonDelete),
            ),
          ],
        );
      },
    );
  }
}
