typedef ContactMessageDoc = ({String id, Map<String, dynamic> map});

abstract interface class ContactMessageRemoteDataSource {
  Future<void> insertMessage(Map<String, dynamic> map);

  Future<List<ContactMessageDoc>> fetchMessageMaps();

  Future<void> markAsRead(String id);

  Future<void> deleteMessage(String id);
}
