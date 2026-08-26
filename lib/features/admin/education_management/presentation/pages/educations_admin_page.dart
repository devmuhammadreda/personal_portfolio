import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../portfolio/domain/entities/education.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import '../cubit/educations_admin_cubit.dart';
import '../cubit/educations_admin_state.dart';

final class EducationsAdminPage extends StatelessWidget {
  const EducationsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EducationsAdminCubit>(
      create: (_) => EducationsAdminCubit(getIt<TimelineRepository>())..load(),
      child: BlocConsumer<EducationsAdminCubit, EducationsAdminState>(
        listener: (context, state) {
          final String? error = state.errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error)));
            context.read<EducationsAdminCubit>().dismissError();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case EducationsAdminStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case EducationsAdminStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ??
                          context.loc.educationsAdminFailedToLoad,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.read<EducationsAdminCubit>().load(),
                      child: Text(context.loc.commonRetry),
                    ),
                  ],
                ),
              );
            case EducationsAdminStatus.ready:
              return const _EducationsList();
          }
        },
      ),
    );
  }
}

class _EducationsList extends StatelessWidget {
  const _EducationsList();

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
                        BlocBuilder<EducationsAdminCubit, EducationsAdminState>(
                          builder: (context, state) => Text(
                            context.loc.educationsAdminCount(
                              state.educations.length,
                            ),
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.adminNewEducation),
                    icon: const Icon(Icons.add_rounded, size: 19),
                    label: Text(context.loc.educationsAdminNew),
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
                      BlocBuilder<EducationsAdminCubit, EducationsAdminState>(
                        builder: (context, state) {
                          if (state.educations.isEmpty) {
                            return Center(
                              child: Text(
                                context.loc.educationsAdminEmpty,
                                style: theme.textTheme.bodyLarge,
                              ),
                            );
                          }
                          return ReorderableListView.builder(
                            buildDefaultDragHandles: true,
                            itemCount: state.educations.length,
                            onReorderItem: (oldIndex, newIndex) => context
                                .read<EducationsAdminCubit>()
                                .reorder(oldIndex, newIndex),
                            itemBuilder: (context, index) {
                              final education = state.educations[index];
                              final bool busy = state.busyIds.contains(
                                education.id,
                              );
                              return _EducationRow(
                                key: ValueKey(
                                  education.id.isEmpty
                                      ? 'row-$index'
                                      : education.id,
                                ),
                                education: education,
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

class _EducationRow extends StatelessWidget {
  const _EducationRow({super.key, required this.education, required this.busy});

  final Education education;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<EducationsAdminCubit>();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: !busy,
      leading: SizedBox(
        width: 42,
        height: 42,
        child: Icon(Icons.school_outlined, color: theme.colorScheme.secondary),
      ),
      title: Text(
        education.degree,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${education.institution} · '
        '${_periodText(context, education.startDate, education.endDate)}',
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
                context.go('${AppRoutes.adminEducations}/${education.id}'),
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

  void _confirmDelete(BuildContext context, EducationsAdminCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.loc.deleteTimelineTitle(education.degree)),
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
                cubit.deleteEducation(education.id);
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
    final DateFormat formatter = DateFormat.y(
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
