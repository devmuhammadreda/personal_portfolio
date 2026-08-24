import '../entities/project.dart';

abstract interface class ProjectRepository {
  /// All projects sorted by their manual [Project.order].
  Future<List<Project>> getProjects();

  /// Persists a new project; returns its generated id.
  Future<String> createProject(Project project);

  Future<void> updateProject(Project project);

  Future<void> deleteProject(String projectId);

  /// Persists the new sort order. [projectIdsInOrder] must contain every
  /// project id; index position becomes the stored `order` value.
  Future<void> reorderProjects(List<String> projectIdsInOrder);
}
