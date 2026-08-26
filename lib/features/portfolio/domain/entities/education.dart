import 'package:equatable/equatable.dart';

class Education extends Equatable {
  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.order,
    this.startDate,
    this.endDate,
    this.grade,
  });

  /// Supabase row id. Empty for a not-yet-persisted entry.
  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String? grade;

  /// Null end date means still studying.
  final DateTime? startDate;
  final DateTime? endDate;

  /// Display order — lower values appear first.
  final int order;

  bool get isNew => id.isEmpty;
  bool get isCurrent => endDate == null;

  Education copyWith({
    String? institution,
    String? degree,
    String? fieldOfStudy,
    String? grade,
    bool clearGrade = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    int? order,
  }) {
    return Education(
      id: id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      grade: clearGrade ? null : (grade ?? this.grade),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    id,
    institution,
    degree,
    fieldOfStudy,
    grade,
    startDate,
    endDate,
    order,
  ];
}
