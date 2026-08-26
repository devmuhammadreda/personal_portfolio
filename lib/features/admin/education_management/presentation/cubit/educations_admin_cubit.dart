import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import 'educations_admin_state.dart';

final class EducationsAdminCubit extends Cubit<EducationsAdminState>
    with CubitLifecycleMixin<EducationsAdminState> {
  EducationsAdminCubit(this._timelineRepository)
    : super(const EducationsAdminState());

  final TimelineRepository _timelineRepository;

  Future<void> load() async {
    emit(state.copyWith(status: EducationsAdminStatus.loading));
    try {
      final educations = await _timelineRepository.getEducation();
      safeEmit(
        state.copyWith(
          status: EducationsAdminStatus.ready,
          educations: educations,
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: EducationsAdminStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> deleteEducation(String id) async {
    _markBusy(id, true);
    try {
      await _timelineRepository.deleteEducation(id);
      safeEmit(
        state.copyWith(
          educations: state.educations.where((e) => e.id != id).toList(),
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(state.copyWith(errorMessage: failure.message));
    } finally {
      _markBusy(id, false);
    }
  }

  /// Optimistic local reorder, then persists the new order server-side.
  /// [newIndex] is the final target index (already adjusted by
  /// ReorderableListView.onReorderItem).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final educations = [...state.educations];
    final moved = educations.removeAt(oldIndex);
    educations.insert(newIndex, moved);

    final reordered = [
      for (var i = 0; i < educations.length; i++)
        educations[i].copyWith(order: i),
    ];
    safeEmit(state.copyWith(educations: reordered));

    try {
      await _timelineRepository.reorderEducation(
        reordered.map((e) => e.id).toList(),
      );
    } on AppFailure catch (failure) {
      safeEmit(state.copyWith(errorMessage: failure.message));
      await load();
    }
  }

  void dismissError() => emit(state.copyWith(clearError: true));

  void _markBusy(String id, bool busy) {
    final busyIds = {...state.busyIds};
    busy ? busyIds.add(id) : busyIds.remove(id);
    emit(state.copyWith(busyIds: busyIds));
  }
}
