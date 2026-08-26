import '../../domain/entities/work_experience.dart';

final class WorkExperienceModel extends WorkExperience {
  const WorkExperienceModel({
    required super.id,
    required super.company,
    required super.position,
    required super.description,
    required super.order,
    super.startDate,
    super.endDate,
    super.location,
  });

  factory WorkExperienceModel.fromMap(Map<String, dynamic> map) {
    return WorkExperienceModel(
      id: map['id'] as String? ?? '',
      company: map['company'] as String? ?? '',
      position: map['position'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] as String?,
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      order: (map['order'] as num?)?.toInt() ?? 0,
    );
  }

  factory WorkExperienceModel.fromEntity(WorkExperience entry) {
    return WorkExperienceModel(
      id: entry.id,
      company: entry.company,
      position: entry.position,
      description: entry.description,
      location: entry.location,
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
      'company': company,
      'position': position,
      'description': description,
      'location': location,
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
