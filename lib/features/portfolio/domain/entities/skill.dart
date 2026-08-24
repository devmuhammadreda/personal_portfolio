import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  const Skill({required this.name, required this.level, this.iconUrl});

  /// Proficiency percentage, clamped to 0–100.
  final int level;
  final String name;
  final String? iconUrl;

  @override
  List<Object?> get props => [name, level, iconUrl];
}
