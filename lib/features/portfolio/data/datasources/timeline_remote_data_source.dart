abstract interface class TimelineRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchWorkExperienceMaps();

  Future<List<Map<String, dynamic>>> fetchEducationMaps();

  /// Persists the map. When [id] is null Postgres generates a uuid; the
  /// resolved id is returned either way.
  Future<String> saveWorkExperienceMap(Map<String, dynamic> map, {String? id});

  Future<void> deleteWorkExperience(String id);

  /// Applies `order` = index for every id in list position.
  Future<void> reorderWorkExperience(List<String> idsInOrder);

  Future<String> saveEducationMap(Map<String, dynamic> map, {String? id});

  Future<void> deleteEducation(String id);

  Future<void> reorderEducation(List<String> idsInOrder);
}
