import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/work_experience.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../datasources/timeline_remote_data_source.dart';
import '../models/education_model.dart';
import '../models/work_experience_model.dart';

class TimelineRepositoryImpl implements TimelineRepository {
  TimelineRepositoryImpl(this._dataSource);

  final TimelineRemoteDataSource _dataSource;

  @override
  Future<List<WorkExperience>> getWorkExperience() async {
    try {
      final rows = await _dataSource.fetchWorkExperienceMaps();
      return rows.map(WorkExperienceModel.fromMap).toList();
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<String> createWorkExperience(WorkExperience entry) async {
    try {
      final map = WorkExperienceModel.fromEntity(entry).toMap();
      return await _dataSource.saveWorkExperienceMap(map);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> updateWorkExperience(WorkExperience entry) async {
    try {
      final map = WorkExperienceModel.fromEntity(entry).toMap();
      await _dataSource.saveWorkExperienceMap(map, id: entry.id);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> deleteWorkExperience(String id) async {
    try {
      await _dataSource.deleteWorkExperience(id);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> reorderWorkExperience(List<String> idsInOrder) async {
    try {
      await _dataSource.reorderWorkExperience(idsInOrder);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<List<Education>> getEducation() async {
    try {
      final rows = await _dataSource.fetchEducationMaps();
      return rows.map(EducationModel.fromMap).toList();
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<String> createEducation(Education entry) async {
    try {
      final map = EducationModel.fromEntity(entry).toMap();
      return await _dataSource.saveEducationMap(map);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> updateEducation(Education entry) async {
    try {
      final map = EducationModel.fromEntity(entry).toMap();
      await _dataSource.saveEducationMap(map, id: entry.id);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> deleteEducation(String id) async {
    try {
      await _dataSource.deleteEducation(id);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> reorderEducation(List<String> idsInOrder) async {
    try {
      await _dataSource.reorderEducation(idsInOrder);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }
}
