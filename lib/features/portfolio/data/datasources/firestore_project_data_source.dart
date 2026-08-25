import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/flavor/flavor_settings.dart';
import 'project_remote_data_source.dart';

class FirestoreProjectDataSource implements ProjectRemoteDataSource {
  FirestoreProjectDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FlavorSettings.projectsCollection);

  Query<Map<String, dynamic>> get _orderedQuery =>
      _collection.orderBy('order', descending: false);

  @override
  Future<List<ProjectDoc>> fetchProjectMaps() async {
    final snapshot = await _orderedQuery.get();
    return snapshot.docs.map((doc) => (id: doc.id, map: doc.data())).toList();
  }

  @override
  Stream<List<ProjectDoc>> watchProjectMaps() {
    return _orderedQuery.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => (id: doc.id, map: doc.data())).toList(),
    );
  }

  @override
  Future<String> saveProjectMap(Map<String, dynamic> map, {String? id}) async {
    if (id == null || id.isEmpty) {
      final docRef = await _collection.add(map);
      return docRef.id;
    }
    await _collection.doc(id).set(map, SetOptions(merge: true));
    return id;
  }

  @override
  Future<void> deleteProject(String id) {
    return _collection.doc(id).delete();
  }

  @override
  Future<void> applyOrder(List<String> projectIdsInOrder) async {
    final WriteBatch batch = _firestore.batch();
    for (final (index, id) in projectIdsInOrder.indexed) {
      batch.update(_collection.doc(id), {'order': index});
    }
    await batch.commit();
  }
}
