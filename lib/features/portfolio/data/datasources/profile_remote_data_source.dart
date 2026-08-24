abstract interface class ProfileRemoteDataSource {
  Future<Map<String, dynamic>?> fetchProfileMap();

  Stream<Map<String, dynamic>?> watchProfileMap();

  Future<void> upsertProfileMap(Map<String, dynamic> map);
}
