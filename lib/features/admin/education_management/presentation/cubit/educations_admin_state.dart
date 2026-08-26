import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/education.dart';

enum EducationsAdminStatus { loading, ready, failure }

final class EducationsAdminState extends Equatable {
  const EducationsAdminState({
    this.status = EducationsAdminStatus.loading,
    this.educations = const [],
    this.busyIds = const {},
    this.errorMessage,
  });

  final EducationsAdminStatus status;
  final List<Education> educations;

  /// Ids with an in-flight mutation (delete / reorder).
  final Set<String> busyIds;
  final String? errorMessage;

  EducationsAdminState copyWith({
    EducationsAdminStatus? status,
    List<Education>? educations,
    Set<String>? busyIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EducationsAdminState(
      status: status ?? this.status,
      educations: educations ?? this.educations,
      busyIds: busyIds ?? this.busyIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, educations, busyIds, errorMessage];
}
