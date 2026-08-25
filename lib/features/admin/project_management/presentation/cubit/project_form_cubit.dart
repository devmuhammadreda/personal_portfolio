import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/errors/app_failure.dart';
import '../../../media/domain/repositories/media_storage_repository.dart';
import '../../../../portfolio/domain/entities/project.dart';
import '../../../../portfolio/domain/entities/project_category.dart';
import '../../../../portfolio/domain/repositories/project_repository.dart';
import 'project_form_state.dart';

final class ProjectFormCubit extends Cubit<ProjectFormState>
    with CubitLifecycleMixin<ProjectFormState> {
  ProjectFormCubit(this._projectRepository, this._mediaStorage)
    : super(const ProjectFormState());

  final ProjectRepository _projectRepository;
  final MediaStorageRepository _mediaStorage;

  /// Loads a blank draft ([projectId] null) or an existing project.
  Future<void> init({String? projectId}) async {
    emit(const ProjectFormState(status: ProjectFormStatus.loading));
    try {
      if (projectId == null || projectId.isEmpty) {
        final int nextOrder = await _nextOrder();
        safeEmit(
          ProjectFormState(
            status: ProjectFormStatus.ready,
            project: _emptyDraft(order: nextOrder),
          ),
        );
        return;
      }
      final projects = await _projectRepository.getProjects();
      final existing = projects.where((p) => p.id == projectId).firstOrNull;
      if (existing == null) {
        safeEmit(
          const ProjectFormState(
            status: ProjectFormStatus.failure,
            errorMessage: 'Project not found. It may have been deleted.',
          ),
        );
        return;
      }
      safeEmit(
        ProjectFormState(status: ProjectFormStatus.ready, project: existing),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        ProjectFormState(
          status: ProjectFormStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void _update(Project Function(Project draft) transform) {
    final current = state.project;
    if (current == null) return;
    emit(state.copyWith(project: transform(current)));
  }

  void setTitle(String value) => _update((d) => d.copyWith(title: value));

  void setRole(String value) => _update((d) => d.copyWith(role: value));

  void setDescription(String value) =>
      _update((d) => d.copyWith(description: value));

  void setLongDescription(String value) =>
      _update((d) => d.copyWith(longDescription: value));

  void setLiveUrl(String value) => _update(
    (d) => d.copyWith(liveUrl: value.trim().isEmpty ? null : value.trim()),
  );

  void setGithubUrl(String value) => _update(
    (d) => d.copyWith(githubUrl: value.trim().isEmpty ? null : value.trim()),
  );

  void setCategory(ProjectCategory category) =>
      _update((d) => d.copyWith(category: category));

  void setFeatured({required bool featured}) =>
      _update((d) => d.copyWith(featured: featured));

  void addTech(String raw) {
    final String tech = raw.trim();
    final current = state.project;
    if (tech.isEmpty || current == null || current.techStack.contains(tech)) {
      return;
    }
    _update((d) => d.copyWith(techStack: [...d.techStack, tech]));
  }

  void removeTechAt(int index) => _update((d) {
    final techStack = [...d.techStack]..removeAt(index);
    return d.copyWith(techStack: techStack);
  });

  /// Multi-selects images, uploads each to Storage and appends the URLs.
  Future<void> addImages() async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    if (files.isEmpty) return;

    safeEmit(state.copyWith(isUploadingImages: true, clearError: true));
    try {
      final List<String> uploadedUrls = [];
      for (final (index, file) in files.indexed) {
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) continue;
        final String extension = file.name.contains('.')
            ? file.name.split('.').last.toLowerCase()
            : 'png';
        final url = await _mediaStorage.uploadBytes(
          storagePath:
              '${StoragePaths.projectImages}/${DateTime.now().millisecondsSinceEpoch}-$index.$extension',
          bytes: bytes,
          contentType: extension == 'jpg' || extension == 'jpeg'
              ? 'image/jpeg'
              : 'image/$extension',
        );
        uploadedUrls.add(url);
      }
      _update((d) => d.copyWith(imageUrls: [...d.imageUrls, ...uploadedUrls]));
    } on AppFailure catch (failure) {
      safeEmit(state.copyWith(errorMessage: failure.message));
    } finally {
      safeEmit(state.copyWith(isUploadingImages: false));
    }
  }

  void removeImageAt(int index) => _update((d) {
    final imageUrls = [...d.imageUrls]..removeAt(index);
    return d.copyWith(imageUrls: imageUrls);
  });

  void dismissError() => emit(state.copyWith(clearError: true));

  bool validate() {
    final project = state.project;
    if (project == null) return false;
    return project.title.trim().isNotEmpty &&
        project.description.trim().isNotEmpty;
  }

  Future<bool> save() async {
    final project = state.project;
    if (project == null || !validate() || state.isBusy) return false;

    emit(state.copyWith(status: ProjectFormStatus.saving, clearError: true));
    try {
      final stamped = project.copyWith(updatedAt: DateTime.now());
      if (stamped.isNew) {
        await _projectRepository.createProject(stamped);
      } else {
        await _projectRepository.updateProject(stamped);
      }
      safeEmit(state.copyWith(status: ProjectFormStatus.saved));
      return true;
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: ProjectFormStatus.ready,
          errorMessage: failure.message,
        ),
      );
      return false;
    }
  }

  Future<int> _nextOrder() async {
    final projects = await _projectRepository.getProjects();
    if (projects.isEmpty) return 0;
    return projects.map((p) => p.order).reduce((a, b) => a > b ? a : b) + 1;
  }

  static Project _emptyDraft({required int order}) {
    final now = DateTime.now();
    return Project(
      id: '',
      title: '',
      description: '',
      longDescription: '',
      techStack: const [],
      role: 'Solo developer',
      imageUrls: const [],
      category: ProjectCategory.mobile,
      featured: false,
      order: order,
      createdAt: now,
      updatedAt: now,
    );
  }
}
