import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../../../portfolio/domain/repositories/timeline_repository.dart';
import 'experiences_admin_state.dart';

final class ExperiencesAdminCubit extends Cubit<ExperiencesAdminState>
    with CubitLifecycleMixin<ExperiencesAdminState> {
  ExperiencesAdminCubit(this._timelineRepository)
    : super(const ExperiencesAdminState());

  final TimelineRepository _timelineRepository;

  Future<void> load() async {
    emit(state.copyWith(status: ExperiencesAdminStatus.loading));
    try {
      final experiences = await _timelineRepository.getWorkExperience();
      safeEmit(
        state.copyWith(
          status: ExperiencesAdminStatus.ready,
          experiences: experiences,
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: ExperiencesAdminStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> deleteExperience(String id) async {
    _markBusy(id, true);
    try {
      await _timelineRepository.deleteWorkExperience(id);
      safeEmit(
        state.copyWith(
          experiences: state.experiences.where((e) => e.id != id).toList(),
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
    final experiences = [...state.experiences];
    final moved = experiences.removeAt(oldIndex);
    experiences.insert(newIndex, moved);

    final reordered = [
      for (var i = 0; i < experiences.length; i++)
        experiences[i].copyWith(order: i),
    ];
    safeEmit(state.copyWith(experiences: reordered));

    try {
      await _timelineRepository.reorderWorkExperience(
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
