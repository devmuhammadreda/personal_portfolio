import 'package:cloud_firestore/cloud_firestore.dart';

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
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  @override
  Future<String> createProject(Project project) async {
    try {
      final map = ProjectModel.fromEntity(project).toMap();
      return await _dataSource.saveProjectMap(map);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      final map = ProjectModel.fromEntity(project).toMap();
      await _dataSource.saveProjectMap(map, id: project.id);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> deleteProject(String projectId) async {
    try {
      await _dataSource.deleteProject(projectId);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> reorderProjects(List<String> projectIdsInOrder) async {
    try {
      await _dataSource.applyOrder(projectIdsInOrder);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  Project _toEntity(ProjectDoc doc) {
    return ProjectModel.fromMap(doc.id, doc.map);
  }
}
