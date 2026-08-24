import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/project.dart';

enum ProjectFormStatus { loading, ready, saving, saved, failure }

final class ProjectFormState extends Equatable {
  const ProjectFormState({
    this.status = ProjectFormStatus.loading,
    this.project,
    this.isUploadingImages = false,
    this.errorMessage,
  });

  final ProjectFormStatus status;

  /// Null only while an existing project is being fetched.
  final Project? project;
  final bool isUploadingImages;
  final String? errorMessage;

  bool get isBusy => status == ProjectFormStatus.saving || isUploadingImages;

  bool get isNew => project?.isNew ?? true;

  ProjectFormState copyWith({
    ProjectFormStatus? status,
    Project? project,
    bool clearProject = false,
    bool? isUploadingImages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectFormState(
      status: status ?? this.status,
      project: clearProject ? null : (project ?? this.project),
      isUploadingImages: isUploadingImages ?? this.isUploadingImages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, project, isUploadingImages, errorMessage];
}
