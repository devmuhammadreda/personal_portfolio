import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../portfolio/domain/entities/project.dart';
import '../../../portfolio/domain/entities/project_category.dart';
import '../../../portfolio/domain/repositories/project_repository.dart';

enum DashboardStatus { loading, ready, failure }

final class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.loading,
    this.projects = const [],
    this.errorMessage,
  });

  final DashboardStatus status;
  final List<Project> projects;
  final String? errorMessage;

  int get totalProjects => projects.length;

  int get featuredCount => projects.where((p) => p.featured).length;

  Map<ProjectCategory, int> get categoryCounts => {
    for (final category in ProjectCategory.values)
      category: projects.where((p) => p.category == category).length,
  };

  List<Project> get recentProjects {
    final sorted = [...projects]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(5).toList();
  }

  DashboardState copyWith({
    DashboardStatus? status,
    List<Project>? projects,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, projects, errorMessage];
}

final class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._projectRepository) : super(const DashboardState());

  final ProjectRepository _projectRepository;

  Future<void> load() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final projects = await _projectRepository.getProjects();
      emit(state.copyWith(status: DashboardStatus.ready, projects: projects));
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }
}
