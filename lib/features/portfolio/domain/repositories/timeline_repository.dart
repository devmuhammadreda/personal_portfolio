import '../../domain/entities/education.dart';
import '../../domain/entities/work_experience.dart';

abstract interface class TimelineRepository {
  /// All entries sorted by their manual [WorkExperience.order].
  Future<List<WorkExperience>> getWorkExperience();

  /// Persists a new entry; returns its generated id.
  Future<String> createWorkExperience(WorkExperience entry);

  Future<void> updateWorkExperience(WorkExperience entry);

  Future<void> deleteWorkExperience(String id);

  /// Persists the new sort order; index position becomes the stored
  /// `order` value.
  Future<void> reorderWorkExperience(List<String> idsInOrder);

  /// All entries sorted by their manual [Education.order].
  Future<List<Education>> getEducation();

  Future<String> createEducation(Education entry);

  Future<void> updateEducation(Education entry);

  Future<void> deleteEducation(String id);

  Future<void> reorderEducation(List<String> idsInOrder);
}
