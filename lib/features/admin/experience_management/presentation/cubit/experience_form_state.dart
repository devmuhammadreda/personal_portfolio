import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/work_experience.dart';

enum ExperienceFormStatus { loading, ready, saving, saved, failure }

final class ExperienceFormState extends Equatable {
  const ExperienceFormState({
    this.status = ExperienceFormStatus.loading,
    this.experience,
    this.errorMessage,
  });

  final ExperienceFormStatus status;

  /// Null only while an existing entry is being fetched.
  final WorkExperience? experience;
  final String? errorMessage;

  bool get isSaving => status == ExperienceFormStatus.saving;

  bool get isNew => experience?.isNew ?? true;

  ExperienceFormState copyWith({
    ExperienceFormStatus? status,
    WorkExperience? experience,
    bool clearExperience = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExperienceFormState(
      status: status ?? this.status,
      experience: clearExperience ? null : (experience ?? this.experience),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, experience, errorMessage];
}
