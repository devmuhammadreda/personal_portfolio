import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import '../cubit/education_form_cubit.dart';
import '../cubit/education_form_state.dart';

final class EducationFormPage extends StatelessWidget {
  const EducationFormPage({super.key, this.educationId});

  final String? educationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EducationFormCubit>(
      create: (_) =>
          EducationFormCubit(getIt<TimelineRepository>())
            ..init(educationId: educationId),
      child: const _EducationFormView(),
    );
  }
}

class _EducationFormView extends StatelessWidget {
  const _EducationFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EducationFormCubit, EducationFormState>(
      listener: (context, state) {
        final String? error = state.errorMessage;
        if (error != null && state.status != EducationFormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error)));
          context.read<EducationFormCubit>().dismissError();
          return;
        }
        if (state.status == EducationFormStatus.failure && error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
        if (state.status == EducationFormStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.educationSavedSnackbar)),
          );
          context.go(AppRoutes.adminEducations);
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case EducationFormStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case EducationFormStatus.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? ''),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => context.go(AppRoutes.adminEducations),
                    child: Text(context.loc.commonClose),
                  ),
                ],
              ),
            );
          case EducationFormStatus.ready:
          case EducationFormStatus.saving:
          case EducationFormStatus.saved:
            if (state.education == null) {
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

  final EducationFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<EducationFormCubit>();

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
                      ? context.loc.educationFormNewHeading
                      : context.loc.educationFormEditHeading,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                _BasicsSection(state: state),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go(AppRoutes.adminEducations),
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

  final EducationFormState state;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final cubit = context.read<EducationFormCubit>();
    final education = state.education!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: ValueKey('institution-${education.id}'),
              initialValue: education.institution.isEmpty
                  ? null
                  : education.institution,
              onChanged: cubit.setInstitution,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? loc.formRequiredField
                  : null,
              decoration: InputDecoration(labelText: loc.formInstitutionField),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('degree-${education.id}'),
              initialValue: education.degree.isEmpty ? null : education.degree,
              onChanged: cubit.setDegree,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? loc.formRequiredField
                  : null,
              decoration: InputDecoration(labelText: loc.formDegreeField),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('field-${education.id}'),
                    initialValue: education.fieldOfStudy.isEmpty
                        ? null
                        : education.fieldOfStudy,
                    onChanged: cubit.setFieldOfStudy,
                    decoration: InputDecoration(
                      labelText: loc.formFieldOfStudyField,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('grade-${education.id}'),
                    initialValue: education.grade,
                    onChanged: cubit.setGrade,
                    decoration: InputDecoration(labelText: loc.formGradeField),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DateField(
                    label: loc.formStartDateField,
                    value: education.startDate,
                    onPicked: cubit.setStartDate,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _DateField(
                    label: loc.formEndDateField,
                    value: education.endDate,
                    onPicked: cubit.setEndDate,
                    enabled: !education.isCurrent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.formCurrentStudySwitchTitle),
              value: education.isCurrent,
              onChanged: (value) => cubit.setCurrent(current: value),
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
