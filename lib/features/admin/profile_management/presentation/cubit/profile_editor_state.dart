import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/profile.dart';

enum ProfileEditorStatus { loading, ready, failure }

final class ProfileEditorState extends Equatable {
  const ProfileEditorState({
    this.status = ProfileEditorStatus.loading,
    this.profile = Profile.empty,
    this.isDirty = false,
    this.isSaving = false,
    this.isUploadingImage = false,
    this.isUploadingResume = false,
    this.errorMessage,
  });

  final ProfileEditorStatus status;
  final Profile profile;

  /// True once any field diverges from the last saved snapshot.
  final bool isDirty;
  final bool isSaving;
  final bool isUploadingImage;
  final bool isUploadingResume;
  final String? errorMessage;

  bool get isBusy => isSaving || isUploadingImage || isUploadingResume;

  ProfileEditorState copyWith({
    ProfileEditorStatus? status,
    Profile? profile,
    bool? isDirty,
    bool? isSaving,
    bool? isUploadingImage,
    bool? isUploadingResume,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileEditorState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isUploadingResume: isUploadingResume ?? this.isUploadingResume,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    isDirty,
    isSaving,
    isUploadingImage,
    isUploadingResume,
    errorMessage,
  ];
}
