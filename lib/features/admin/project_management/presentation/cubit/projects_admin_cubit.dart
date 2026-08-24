import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../portfolio/domain/entities/project.dart';
import '../../../../portfolio/domain/repositories/project_repository.dart';
import 'projects_admin_state.dart';

final class ProjectsAdminCubit extends Cubit<ProjectsAdminState> {
  ProjectsAdminCubit(this._projectRepository)
    : super(const ProjectsAdminState());

  final ProjectRepository _projectRepository;

  Future<void> load() async {
    emit(state.copyWith(status: ProjectsAdminStatus.loading, clearError: true));
    try {
      final projects = await _projectRepository.getProjects();
      emit(
        state.copyWith(status: ProjectsAdminStatus.ready, projects: projects),
      );
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: ProjectsAdminStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> toggleFeatured(Project project) async {
    _markBusy(project.id, true);
    try {
      await _projectRepository.updateProject(
        project.copyWith(featured: !project.featured),
      );
      final projects =
          state.projects
              .map(
                (p) => p.id == project.id
                    ? p.copyWith(featured: !p.featured)
                    : p,
              )
              .toList();
      emit(state.copyWith(projects: projects, clearInfo: true));
    } on AppFailure catch (failure) {
      emit(state.copyWith(errorMessage: failure.message));
    } finally {
      _markBusy(project.id, false);
    }
  }

  Future<void> deleteProject(String projectId) async {
    _markBusy(projectId, true);
    try {
      await _projectRepository.deleteProject(projectId);
      emit(
        state.copyWith(
          projects: state.projects.where((p) => p.id != projectId).toList(),
        ),
      );
    } on AppFailure catch (failure) {
      emit(state.copyWith(errorMessage: failure.message));
    } finally {
      _markBusy(projectId, false);
    }
  }

  /// Optimistic local reorder, then persists the new order server-side.
  /// [newIndex] is the final target index (already adjusted by
  /// ReorderableListView.onReorderItem).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final projects = [...state.projects];
    final moved = projects.removeAt(oldIndex);
    projects.insert(newIndex, moved);

    final reordered = [
      for (var i = 0; i < projects.length; i++)
        projects[i].copyWith(order: i),
    ];
    emit(state.copyWith(projects: reordered));

    try {
      await _projectRepository.reorderProjects(reordered.map((p) => p.id).toList());
    } on AppFailure catch (failure) {
      emit(state.copyWith(errorMessage: failure.message));
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
