import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/flavor/flavor_settings.dart';
import 'profile_remote_data_source.dart';

class FirestoreProfileDataSource implements ProfileRemoteDataSource {
  FirestoreProfileDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FlavorSettings.profileCollection)
      .doc(FirestoreDocs.mainProfile);

  @override
  Future<Map<String, dynamic>?> fetchProfileMap() async {
    final snapshot = await _doc.get();
    return snapshot.data();
  }

  @override
  Stream<Map<String, dynamic>?> watchProfileMap() {
    return _doc.snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return snapshot.data();
    });
  }

  @override
  Future<void> upsertProfileMap(Map<String, dynamic> map) {
    return _doc.set(map, SetOptions(merge: true));
  }
}
