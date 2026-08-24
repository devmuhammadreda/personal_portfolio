import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_failure.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Future<Profile> getProfile() async {
    try {
      final map = await _dataSource.fetchProfileMap();
      if (map == null) return Profile.empty;
      return ProfileModel.fromMap(map);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }

  @override
  Stream<Profile> watchProfile() {
    return _dataSource.watchProfileMap().map(
      (map) => map == null ? Profile.empty : ProfileModel.fromMap(map),
    );
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    try {
      final map = ProfileModel.fromEntity(profile).toMap();
      await _dataSource.upsertProfileMap(map);
    } on FirebaseException catch (error) {
      throw FirestoreFailure.fromCode(error.code);
    }
  }
}
