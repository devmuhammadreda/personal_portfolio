import '../../domain/entities/education.dart';

final class EducationModel extends Education {
  const EducationModel({
    required super.id,
    required super.institution,
    required super.degree,
    required super.fieldOfStudy,
    required super.order,
    super.startDate,
    super.endDate,
    super.grade,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      degree: map['degree'] as String? ?? '',
      fieldOfStudy: map['fieldOfStudy'] as String? ?? '',
      grade: map['grade'] as String?,
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      order: (map['order'] as num?)?.toInt() ?? 0,
    );
  }

  factory EducationModel.fromEntity(Education entry) {
    return EducationModel(
      id: entry.id,
      institution: entry.institution,
      degree: entry.degree,
      fieldOfStudy: entry.fieldOfStudy,
      grade: entry.grade,
      startDate: entry.startDate,
      endDate: entry.endDate,
      order: entry.order,
    );
  }

  /// Row payload without the id — the data source passes it separately so
  /// inserts let Postgres generate a uuid while updates target it.
  ///
  /// Nullable columns are always present so updates can persist cleared
  /// values as SQL NULL.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'grade': grade,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'order': order,
    };
  }

  static DateTime? _parseDate(Object? raw) => switch (raw) {
    final DateTime date => date,
    final String text when text.isNotEmpty => DateTime.tryParse(text),
    _ => null,
  };
}
