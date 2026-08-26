import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/work_experience.dart';

enum ExperiencesAdminStatus { loading, ready, failure }

final class ExperiencesAdminState extends Equatable {
  const ExperiencesAdminState({
    this.status = ExperiencesAdminStatus.loading,
    this.experiences = const [],
    this.busyIds = const {},
    this.errorMessage,
  });

  final ExperiencesAdminStatus status;
  final List<WorkExperience> experiences;

  /// Ids with an in-flight mutation (delete / reorder).
  final Set<String> busyIds;
  final String? errorMessage;

  ExperiencesAdminState copyWith({
    ExperiencesAdminStatus? status,
    List<WorkExperience>? experiences,
    Set<String>? busyIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExperiencesAdminState(
      status: status ?? this.status,
      experiences: experiences ?? this.experiences,
      busyIds: busyIds ?? this.busyIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, experiences, busyIds, errorMessage];
}
