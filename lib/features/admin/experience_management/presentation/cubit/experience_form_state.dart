import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/work_experience.dart';

enum ExperienceFormStatus { loading, ready, saving, saved, failure }

final class ExperienceFormState extends Equatable {
  const ExperienceFormState({
    this.status = ExperienceFormStatus.loading,
    this.experience,
    this.isCurrent = false,
    this.errorMessage,
  });

  final ExperienceFormStatus status;

  /// Null only while an existing entry is being fetched.
  final WorkExperience? experience;

  /// Explicit "still working here" intent — independent of
  /// [WorkExperience.endDate] so the switch stays togglable while no end
  /// date has been picked yet.
  final bool isCurrent;
  final String? errorMessage;

  bool get isSaving => status == ExperienceFormStatus.saving;

  bool get isNew => experience?.isNew ?? true;

  ExperienceFormState copyWith({
    ExperienceFormStatus? status,
    WorkExperience? experience,
    bool clearExperience = false,
    bool? isCurrent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExperienceFormState(
      status: status ?? this.status,
      experience: clearExperience ? null : (experience ?? this.experience),
      isCurrent: isCurrent ?? this.isCurrent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, experience, isCurrent, errorMessage];
}
