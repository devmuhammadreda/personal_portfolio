import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/education.dart';

enum EducationFormStatus { loading, ready, saving, saved, failure }

final class EducationFormState extends Equatable {
  const EducationFormState({
    this.status = EducationFormStatus.loading,
    this.education,
    this.errorMessage,
  });

  final EducationFormStatus status;

  /// Null only while an existing entry is being fetched.
  final Education? education;
  final String? errorMessage;

  bool get isSaving => status == EducationFormStatus.saving;

  bool get isNew => education?.isNew ?? true;

  EducationFormState copyWith({
    EducationFormStatus? status,
    Education? education,
    bool clearEducation = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EducationFormState(
      status: status ?? this.status,
      education: clearEducation ? null : (education ?? this.education),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, education, errorMessage];
}
