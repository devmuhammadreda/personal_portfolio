import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../portfolio/domain/entities/work_experience.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import '../cubit/experiences_admin_cubit.dart';
import '../cubit/experiences_admin_state.dart';

final class ExperiencesAdminPage extends StatelessWidget {
  const ExperiencesAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExperiencesAdminCubit>(
      create: (_) => ExperiencesAdminCubit(getIt<TimelineRepository>())..load(),
      child: BlocConsumer<ExperiencesAdminCubit, ExperiencesAdminState>(
        listener: (context, state) {
          final String? error = state.errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error)));
            context.read<ExperiencesAdminCubit>().dismissError();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ExperiencesAdminStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ExperiencesAdminStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ??
                          context.loc.experiencesAdminFailedToLoad,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.read<ExperiencesAdminCubit>().load(),
                      child: Text(context.loc.commonRetry),
                    ),
                  ],
                ),
              );
            case ExperiencesAdminStatus.ready:
              return const _ExperiencesList();
          }
        },
      ),
    );
  }
}

class _ExperiencesList extends StatelessWidget {
  const _ExperiencesList();

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
                    child:
                        BlocBuilder<
                          ExperiencesAdminCubit,
                          ExperiencesAdminState
                        >(
                          builder: (context, state) => Text(
                            context.loc.experiencesAdminCount(
                              state.experiences.length,
                            ),
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.adminNewExperience),
                    icon: const Icon(Icons.add_rounded, size: 19),
                    label: Text(context.loc.experiencesAdminNew),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                context.loc.timelineReorderHint,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child:
                      BlocBuilder<ExperiencesAdminCubit, ExperiencesAdminState>(
                        builder: (context, state) {
                          if (state.experiences.isEmpty) {
                            return Center(
                              child: Text(
                                context.loc.experiencesAdminEmpty,
                                style: theme.textTheme.bodyLarge,
                              ),
                            );
                          }
                          return ReorderableListView.builder(
                            buildDefaultDragHandles: true,
                            itemCount: state.experiences.length,
                            onReorderItem: (oldIndex, newIndex) => context
                                .read<ExperiencesAdminCubit>()
                                .reorder(oldIndex, newIndex),
                            itemBuilder: (context, index) {
                              final experience = state.experiences[index];
                              final bool busy = state.busyIds.contains(
                                experience.id,
                              );
                              return _ExperienceRow(
                                key: ValueKey(
                                  experience.id.isEmpty
                                      ? 'row-$index'
                                      : experience.id,
                                ),
                                experience: experience,
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

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({
    super.key,
    required this.experience,
    required this.busy,
  });

  final WorkExperience experience;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ExperiencesAdminCubit>();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: !busy,
      leading: SizedBox(
        width: 42,
        height: 42,
        child: Icon(
          Icons.work_outline_rounded,
          color: theme.colorScheme.secondary,
        ),
      ),
      title: Text(
        experience.position,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${experience.company} · '
        '${_periodText(context, experience.startDate, experience.endDate)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Wrap(
        spacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            tooltip: context.loc.commonEdit,
            onPressed: () =>
                context.go('${AppRoutes.adminExperiences}/${experience.id}'),
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

  void _confirmDelete(BuildContext context, ExperiencesAdminCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.loc.deleteTimelineTitle(experience.position)),
          content: Text(context.loc.deleteTimelineBody),
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
                cubit.deleteExperience(experience.id);
              },
              child: Text(context.loc.commonDelete),
            ),
          ],
        );
      },
    );
  }

  static String _periodText(
    BuildContext context,
    DateTime? start,
    DateTime? end,
  ) {
    final DateFormat formatter = DateFormat.yMMM(
      Localizations.localeOf(context).toString(),
    );
    final String startText = start == null ? '' : formatter.format(start);
    final String endText = end == null
        ? context.loc.timelinePresent
        : formatter.format(end);
    if (startText.isEmpty) return endText;
    return '$startText – $endText';
  }
}
