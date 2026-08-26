import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import '../cubit/experience_form_cubit.dart';
import '../cubit/experience_form_state.dart';

final class ExperienceFormPage extends StatelessWidget {
  const ExperienceFormPage({super.key, this.experienceId});

  final String? experienceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExperienceFormCubit>(
      create: (_) =>
          ExperienceFormCubit(getIt<TimelineRepository>())
            ..init(experienceId: experienceId),
      child: const _ExperienceFormView(),
    );
  }
}

class _ExperienceFormView extends StatelessWidget {
  const _ExperienceFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExperienceFormCubit, ExperienceFormState>(
      listener: (context, state) {
        final String? error = state.errorMessage;
        if (error != null && state.status != ExperienceFormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error)));
          context.read<ExperienceFormCubit>().dismissError();
          return;
        }
        if (state.status == ExperienceFormStatus.failure && error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
        if (state.status == ExperienceFormStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.experienceSavedSnackbar)),
          );
          context.go(AppRoutes.adminExperiences);
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case ExperienceFormStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ExperienceFormStatus.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? ''),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => context.go(AppRoutes.adminExperiences),
                    child: Text(context.loc.commonClose),
                  ),
                ],
              ),
            );
          case ExperienceFormStatus.ready:
          case ExperienceFormStatus.saving:
          case ExperienceFormStatus.saved:
            if (state.experience == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return _FormBody(state: state);
        }
      },
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({required this.state});

  final ExperienceFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ExperienceFormCubit>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isNew
                      ? context.loc.experienceFormNewHeading
                      : context.loc.experienceFormEditHeading,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                _BasicsSection(state: state),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go(AppRoutes.adminExperiences),
                      child: Text(context.loc.commonCancel),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: state.isSaving ? null : () => cubit.save(),
                      icon: state.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_rounded, size: 18),
                      label: Text(
                        state.isSaving
                            ? context.loc.profileSaving
                            : context.loc.profileSaveChanges,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicsSection extends StatelessWidget {
  const _BasicsSection({required this.state});

  final ExperienceFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final loc = context.loc;
    final cubit = context.read<ExperienceFormCubit>();
    final experience = state.experience!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: ValueKey('company-${experience.id}'),
              initialValue: experience.company.isEmpty
                  ? null
                  : experience.company,
              onChanged: cubit.setCompany,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? loc.formRequiredField
                  : null,
              decoration: InputDecoration(labelText: loc.formCompanyField),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('position-${experience.id}'),
              initialValue: experience.position.isEmpty
                  ? null
                  : experience.position,
              onChanged: cubit.setPosition,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? loc.formRequiredField
                  : null,
              decoration: InputDecoration(labelText: loc.formPositionField),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('location-${experience.id}'),
              initialValue: experience.location,
              onChanged: cubit.setLocation,
              decoration: InputDecoration(labelText: loc.formLocationField),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('description-${experience.id}'),
              initialValue: experience.description.isEmpty
                  ? null
                  : experience.description,
              onChanged: cubit.setDescription,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: loc.formEntryDescription,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DateField(
                    label: loc.formStartDateField,
                    value: experience.startDate,
                    onPicked: cubit.setStartDate,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _DateField(
                    label: loc.formEndDateField,
                    value: state.isCurrent ? null : experience.endDate,
                    onPicked: cubit.setEndDate,
                    enabled: !state.isCurrent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.formCurrentWorkSwitchTitle),
              value: state.isCurrent,
              onChanged: (value) => cubit.setCurrent(current: value),
            ),
            if (state.isSaving)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  context.loc.profileSaving,
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Read-only field opening a date picker; the clear action passes null.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
    this.enabled = true,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPicked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final String formatted = value == null
        ? ''
        : DateFormat.yMMMd(Localizations.localeOf(context).toString())
              .format(value!);

    return TextFormField(
      key: ValueKey('$label-$formatted-$enabled'),
      initialValue: formatted.isEmpty ? null : formatted,
      readOnly: true,
      enabled: enabled,
      showCursor: false,
      onTap: enabled
          ? () async {
              final now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime(now.year - 1, now.month),
                firstDate: DateTime(1950),
                lastDate: DateTime(now.year + 10),
              );
              if (picked != null) onPicked(picked);
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: !enabled || value == null
            ? const Icon(Icons.calendar_today_outlined)
            : IconButton(
                tooltip: loc.commonRemove,
                onPressed: () => onPicked(null),
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}
