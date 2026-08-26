import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/education.dart';

enum EducationFormStatus { loading, ready, saving, saved, failure }

final class EducationFormState extends Equatable {
  const EducationFormState({
    this.status = EducationFormStatus.loading,
    this.education,
    this.isCurrent = false,
    this.errorMessage,
  });

  final EducationFormStatus status;

  /// Null only while an existing entry is being fetched.
  final Education? education;

  /// Explicit "still studying" intent — independent of [Education.endDate]
  /// so the switch stays togglable while no end date has been picked yet.
  final bool isCurrent;
  final String? errorMessage;

  bool get isSaving => status == EducationFormStatus.saving;

  bool get isNew => education?.isNew ?? true;

  EducationFormState copyWith({
    EducationFormStatus? status,
    Education? education,
    bool clearEducation = false,
    bool? isCurrent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EducationFormState(
      status: status ?? this.status,
      education: clearEducation ? null : (education ?? this.education),
      isCurrent: isCurrent ?? this.isCurrent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, education, isCurrent, errorMessage];
}
