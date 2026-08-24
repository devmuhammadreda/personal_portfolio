typedef ProjectDoc = ({String id, Map<String, dynamic> map});

abstract interface class ProjectRemoteDataSource {
  Future<List<ProjectDoc>> fetchProjectMaps();

  Stream<List<ProjectDoc>> watchProjectMaps();

  /// Persists the map. When [id] is null a Firestore document id is
  /// generated; the resolved document id is returned either way.
  Future<String> saveProjectMap(Map<String, dynamic> map, {String? id});

  Future<void> deleteProject(String id);

  /// Applies `order` = index for every projectId in list position.
  Future<void> applyOrder(List<String> projectIdsInOrder);
}
