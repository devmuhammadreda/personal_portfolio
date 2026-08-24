import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/app_failure.dart';
import '../../../media/domain/repositories/media_storage_repository.dart';
import '../../../../portfolio/domain/entities/profile.dart';
import '../../../../portfolio/domain/entities/skill.dart';
import '../../../../portfolio/domain/entities/social_links.dart';
import '../../../../portfolio/domain/repositories/profile_repository.dart';
import 'profile_editor_state.dart';

enum SocialField { github, linkedin, twitter, email, whatsapp }

final class ProfileEditorCubit extends Cubit<ProfileEditorState> {
  ProfileEditorCubit(this._profileRepository, this._mediaStorageRepository)
    : super(const ProfileEditorState());

  final ProfileRepository _profileRepository;
  final MediaStorageRepository _mediaStorageRepository;

  Profile? _savedSnapshot;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileEditorStatus.loading));
    try {
      final profile = await _profileRepository.getProfile();
      _savedSnapshot = profile;
      emit(
        state.copyWith(
          status: ProfileEditorStatus.ready,
          profile: profile,
          isDirty: false,
        ),
      );
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: ProfileEditorStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void _emitProfile(Profile profile) {
    emit(state.copyWith(profile: profile, isDirty: profile != _savedSnapshot));
  }

  void setName(String value) =>
      _emitProfile(state.profile.copyWith(name: value));

  void setTitle(String value) =>
      _emitProfile(state.profile.copyWith(title: value));

  void setTagline(String value) =>
      _emitProfile(state.profile.copyWith(tagline: value));

  void setAboutMe(String value) =>
      _emitProfile(state.profile.copyWith(aboutMe: value));

  void setYearsOfExperience(String value) {
    final int years = int.tryParse(value) ?? state.profile.yearsOfExperience;
    _emitProfile(
      state.profile.copyWith(yearsOfExperience: years.clamp(0, 80)),
    );
  }

  void setAvailableForWork({required bool available}) =>
      _emitProfile(state.profile.copyWith(availableForWork: available));

  void addSkill() {
    final skills = [...state.profile.skills, const Skill(name: '', level: 60)];
    _emitProfile(state.profile.copyWith(skills: skills));
  }

  void renameSkill(int index, String name) {
    final skills = [...state.profile.skills];
    if (index < 0 || index >= skills.length) return;
    skills[index] = skills[index].copyWithSkill(name: name);
    _emitProfile(state.profile.copyWith(skills: skills));
  }

  void setSkillLevel(int index, double level) {
    final skills = [...state.profile.skills];
    if (index < 0 || index >= skills.length) return;
    skills[index] = skills[index].copyWithSkill(level: level.round().clamp(0, 100));
    _emitProfile(state.profile.copyWith(skills: skills));
  }

  void removeSkill(int index) {
    final skills = [...state.profile.skills]..removeAt(index);
    _emitProfile(state.profile.copyWith(skills: skills));
  }

  void setSocialLink(SocialField field, String value) {
    final current = state.profile.socialLinks;
    final String? cleaned = value.trim().isEmpty ? null : value.trim();
    final SocialLinks updated = switch (field) {
      SocialField.github => _withSocial(current, github: cleaned),
      SocialField.linkedin => _withSocial(current, linkedin: cleaned),
      SocialField.twitter => _withSocial(current, twitter: cleaned),
      SocialField.email => _withSocial(current, email: cleaned),
      SocialField.whatsapp => _withSocial(current, whatsapp: cleaned),
    };
    _emitProfile(state.profile.copyWith(socialLinks: updated));
  }

  static SocialLinks _withSocial(
    SocialLinks base, {
    String? github,
    String? linkedin,
    String? twitter,
    String? email,
    String? whatsapp,
  }) {
    return SocialLinks(
      github: github ?? base.github,
      linkedin: linkedin ?? base.linkedin,
      twitter: twitter ?? base.twitter,
      email: email ?? base.email,
      whatsapp: whatsapp ?? base.whatsapp,
    );
  }

  /// Picks an image client-side, uploads it to Storage and stores the
  /// resulting URL in the draft. Persisted only on save.
  Future<void> pickAndUploadPhoto() async {
    final Uint8List? bytes = await _pickBytes(FileType.image);
    if (bytes == null || bytes.isEmpty) return;
    emit(state.copyWith(isUploadingImage: true));
    try {
      final url = await _mediaStorageRepository.uploadBytes(
        storagePath:
            '${StoragePaths.profileImages}/photo-${DateTime.now().millisecondsSinceEpoch}.png',
        bytes: bytes,
        contentType: 'image/png',
      );
      _emitProfile(state.profile.copyWith(profileImageUrl: url));
    } on AppFailure catch (failure) {
      emit(state.copyWith(errorMessage: failure.message));
    } finally {
      emit(state.copyWith(isUploadingImage: false));
    }
  }

  void clearPhoto() =>
      _emitProfile(state.profile.copyWith(clearProfileImageUrl: true));

  Future<void> pickAndUploadResume() async {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (file == null) return;
    final Uint8List bytes = await file.readAsBytes();
    if (bytes.isEmpty) return;
    emit(state.copyWith(isUploadingResume: true));
    try {
      final url = await _mediaStorageRepository.uploadBytes(
        storagePath:
            '${StoragePaths.resumeFiles}/resume-${DateTime.now().millisecondsSinceEpoch}.pdf',
        bytes: bytes,
        contentType: 'application/pdf',
      );
      _emitProfile(state.profile.copyWith(resumeUrl: url));
    } on AppFailure catch (failure) {
      emit(state.copyWith(errorMessage: failure.message));
    } finally {
      emit(state.copyWith(isUploadingResume: false));
    }
  }

  Future<void> save() async {
    if (!state.isDirty || state.isBusy) return;
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      await _profileRepository.saveProfile(state.profile);
      _savedSnapshot = state.profile;
      emit(state.copyWith(isSaving: false, isDirty: false));
    } on AppFailure catch (failure) {
      emit(state.copyWith(isSaving: false, errorMessage: failure.message));
    }
  }

  void dismissError() => emit(state.copyWith(clearError: true));

  Future<Uint8List?> _pickBytes(FileType type) async {
    final PlatformFile? file = await FilePicker.pickFile(type: type);
    if (file == null) return null;
    return file.readAsBytes();
  }
}
