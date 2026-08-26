import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.description,
    required this.order,
    this.startDate,
    this.endDate,
    this.location,
  });

  /// Supabase row id. Empty for a not-yet-persisted entry.
  final String id;
  final String company;
  final String position;
  final String description;
  final String? location;

  /// Null means the timeline shows only the end side of the range.
  final DateTime? startDate;

  /// Null means the role is ongoing.
  final DateTime? endDate;

  /// Display order — lower values appear first.
  final int order;

  bool get isNew => id.isEmpty;
  bool get isCurrent => endDate == null;

  WorkExperience copyWith({
    String? company,
    String? position,
    String? description,
    String? location,
    bool clearLocation = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    int? order,
  }) {
    return WorkExperience(
      id: id,
      company: company ?? this.company,
      position: position ?? this.position,
      description: description ?? this.description,
      location: clearLocation ? null : (location ?? this.location),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    id,
    company,
    position,
    description,
    location,
    startDate,
    endDate,
    order,
  ];
}
