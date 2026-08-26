import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../../../portfolio/domain/entities/work_experience.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import 'experience_form_state.dart';

final class ExperienceFormCubit extends Cubit<ExperienceFormState>
    with CubitLifecycleMixin<ExperienceFormState> {
  ExperienceFormCubit(this._timelineRepository)
    : super(const ExperienceFormState());

  final TimelineRepository _timelineRepository;

  /// Loads a blank draft ([experienceId] null) or an existing entry.
  Future<void> init({String? experienceId}) async {
    emit(const ExperienceFormState(status: ExperienceFormStatus.loading));
    try {
      if (experienceId == null || experienceId.isEmpty) {
        final int nextOrder = await _nextOrder();
        safeEmit(
          ExperienceFormState(
            status: ExperienceFormStatus.ready,
            experience: _emptyDraft(order: nextOrder),
          ),
        );
        return;
      }
      final experiences = await _timelineRepository.getWorkExperience();
      final existing = experiences
          .where((e) => e.id == experienceId)
          .firstOrNull;
      if (existing == null) {
        safeEmit(
          const ExperienceFormState(
            status: ExperienceFormStatus.failure,
            errorMessage: 'Entry not found. It may have been deleted.',
          ),
        );
        return;
      }
      safeEmit(
        ExperienceFormState(
          status: ExperienceFormStatus.ready,
          experience: existing,
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        ExperienceFormState(
          status: ExperienceFormStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void _update(WorkExperience Function(WorkExperience draft) transform) {
    final current = state.experience;
    if (current == null) return;
    emit(state.copyWith(experience: transform(current)));
  }

  void setCompany(String value) => _update((d) => d.copyWith(company: value));

  void setPosition(String value) => _update((d) => d.copyWith(position: value));

  void setLocation(String value) => _update(
    (d) => d.copyWith(location: value, clearLocation: value.trim().isEmpty),
  );

  void setDescription(String value) =>
      _update((d) => d.copyWith(description: value));

  void setStartDate(DateTime? value) => _update(
    (d) => d.copyWith(startDate: value, clearStartDate: value == null),
  );

  void setEndDate(DateTime? value) =>
      _update((d) => d.copyWith(endDate: value, clearEndDate: value == null));

  /// Marks the role as ongoing by clearing the end date.
  void setCurrent({required bool current}) =>
      current ? _update((d) => d.copyWith(clearEndDate: true)) : null;

  void dismissError() => emit(state.copyWith(clearError: true));

  bool validate() {
    final experience = state.experience;
    if (experience == null) return false;
    return experience.company.trim().isNotEmpty &&
        experience.position.trim().isNotEmpty;
  }

  Future<bool> save() async {
    final experience = state.experience;
    if (experience == null || !validate() || state.isSaving) return false;

    emit(state.copyWith(status: ExperienceFormStatus.saving, clearError: true));
    try {
      if (experience.isNew) {
        await _timelineRepository.createWorkExperience(experience);
      } else {
        await _timelineRepository.updateWorkExperience(experience);
      }
      safeEmit(state.copyWith(status: ExperienceFormStatus.saved));
      return true;
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: ExperienceFormStatus.ready,
          errorMessage: failure.message,
        ),
      );
      return false;
    }
  }

  Future<int> _nextOrder() async {
    final experiences = await _timelineRepository.getWorkExperience();
    if (experiences.isEmpty) return 0;
    return experiences.map((e) => e.order).reduce((a, b) => a > b ? a : b) + 1;
  }

  static WorkExperience _emptyDraft({required int order}) {
    return WorkExperience(
      id: '',
      company: '',
      position: '',
      description: '',
      order: order,
    );
  }
}
