import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../../../portfolio/domain/entities/education.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import 'education_form_state.dart';

final class EducationFormCubit extends Cubit<EducationFormState>
    with CubitLifecycleMixin<EducationFormState> {
  EducationFormCubit(this._timelineRepository)
    : super(const EducationFormState());

  final TimelineRepository _timelineRepository;

  /// Loads a blank draft ([educationId] null) or an existing entry.
  Future<void> init({String? educationId}) async {
    emit(const EducationFormState(status: EducationFormStatus.loading));
    try {
      if (educationId == null || educationId.isEmpty) {
        final int nextOrder = await _nextOrder();
        safeEmit(
          EducationFormState(
            status: EducationFormStatus.ready,
            education: _emptyDraft(order: nextOrder),
          ),
        );
        return;
      }
      final educations = await _timelineRepository.getEducation();
      final existing = educations.where((e) => e.id == educationId).firstOrNull;
      if (existing == null) {
        safeEmit(
          const EducationFormState(
            status: EducationFormStatus.failure,
            errorMessage: 'Entry not found. It may have been deleted.',
          ),
        );
        return;
      }
      safeEmit(
        EducationFormState(
          status: EducationFormStatus.ready,
          education: existing,
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        EducationFormState(
          status: EducationFormStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void _update(Education Function(Education draft) transform) {
    final current = state.education;
    if (current == null) return;
    emit(state.copyWith(education: transform(current)));
  }

  void setInstitution(String value) =>
      _update((d) => d.copyWith(institution: value));

  void setDegree(String value) => _update((d) => d.copyWith(degree: value));

  void setFieldOfStudy(String value) =>
      _update((d) => d.copyWith(fieldOfStudy: value));

  void setGrade(String value) => _update(
    (d) => d.copyWith(grade: value, clearGrade: value.trim().isEmpty),
  );

  void setStartDate(DateTime? value) => _update(
    (d) => d.copyWith(startDate: value, clearStartDate: value == null),
  );

  void setEndDate(DateTime? value) =>
      _update((d) => d.copyWith(endDate: value, clearEndDate: value == null));

  /// Marks the studies as ongoing by clearing the end date.
  void setCurrent({required bool current}) =>
      current ? _update((d) => d.copyWith(clearEndDate: true)) : null;

  void dismissError() => emit(state.copyWith(clearError: true));

  bool validate() {
    final education = state.education;
    if (education == null) return false;
    return education.institution.trim().isNotEmpty &&
        education.degree.trim().isNotEmpty;
  }

  Future<bool> save() async {
    final education = state.education;
    if (education == null || !validate() || state.isSaving) return false;

    emit(state.copyWith(status: EducationFormStatus.saving, clearError: true));
    try {
      if (education.isNew) {
        await _timelineRepository.createEducation(education);
      } else {
        await _timelineRepository.updateEducation(education);
      }
      safeEmit(state.copyWith(status: EducationFormStatus.saved));
      return true;
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: EducationFormStatus.ready,
          errorMessage: failure.message,
        ),
      );
      return false;
    }
  }

  Future<int> _nextOrder() async {
    final educations = await _timelineRepository.getEducation();
    if (educations.isEmpty) return 0;
    return educations.map((e) => e.order).reduce((a, b) => a > b ? a : b) + 1;
  }

  static Education _emptyDraft({required int order}) {
    return Education(
      id: '',
      institution: '',
      degree: '',
      fieldOfStudy: '',
      order: order,
    );
  }
}
