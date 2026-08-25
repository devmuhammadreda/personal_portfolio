import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../datasources/project_remote_data_source.dart';
import '../models/project_model.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(this._dataSource);

  final ProjectRemoteDataSource _dataSource;

  @override
  Future<List<Project>> getProjects() async {
    try {
      final docs = await _dataSource.fetchProjectMaps();
      return docs.map(_toEntity).toList();
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<String> createProject(Project project) async {
    try {
      final map = ProjectModel.fromEntity(project).toMap();
      return await _dataSource.saveProjectMap(map);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      final map = ProjectModel.fromEntity(project).toMap();
      await _dataSource.saveProjectMap(map, id: project.id);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    try {
      await _dataSource.deleteProject(projectId);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> reorderProjects(List<String> projectIdsInOrder) async {
    try {
      await _dataSource.applyOrder(projectIdsInOrder);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  Project _toEntity(ProjectDoc doc) {
    return ProjectModel.fromMap(doc.id, doc.map);
  }
}
