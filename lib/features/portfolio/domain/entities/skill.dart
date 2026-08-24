import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  const Skill({required this.name, required this.level, this.iconUrl});

  /// Proficiency percentage, clamped to 0–100.
  final int level;
  final String name;
  final String? iconUrl;

  Skill copyWithSkill({String? name, int? level, String? iconUrl}) {
    return Skill(
      name: name ?? this.name,
      level: level ?? this.level,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  List<Object?> get props => [name, level, iconUrl];
}
