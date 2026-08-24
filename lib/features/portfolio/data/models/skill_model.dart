import '../../domain/entities/skill.dart';

final class SkillModel extends Skill {
  const SkillModel({required super.name, required super.level, super.iconUrl});

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map['name'] as String? ?? '',
      level: _clampLevel((map['level'] as num?)?.toInt() ?? 0),
      iconUrl: map['iconUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'level': level,
      if (iconUrl != null) 'iconUrl': iconUrl,
    };
  }

  static int _clampLevel(int level) => level.clamp(0, 100);
}
