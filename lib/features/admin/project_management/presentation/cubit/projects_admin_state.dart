import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/project.dart';

enum ProjectsAdminStatus { loading, ready, failure }

final class ProjectsAdminState extends Equatable {
  const ProjectsAdminState({
    this.status = ProjectsAdminStatus.loading,
    this.projects = const [],
    this.busyIds = const {},
    this.errorMessage,
    this.infoMessage,
  });

  final ProjectsAdminStatus status;
  final List<Project> projects;

  /// Ids with an in-flight mutation (delete / feature toggle / reorder).
  final Set<String> busyIds;
  final String? errorMessage;
  final String? infoMessage;

  int get featuredCount => projects.where((p) => p.featured).length;

  ProjectsAdminState copyWith({
    ProjectsAdminStatus? status,
    List<Project>? projects,
    Set<String>? busyIds,
    String? errorMessage,
    String? infoMessage,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return ProjectsAdminState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      busyIds: busyIds ?? this.busyIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    projects,
    busyIds,
    errorMessage,
    infoMessage,
  ];
}
