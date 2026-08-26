import '../../domain/entities/skill_group.dart';
import 'skill_model.dart';

final class SkillGroupModel extends SkillGroup {
  const SkillGroupModel({required super.category, required super.skills});

  factory SkillGroupModel.fromMap(Map<String, dynamic> map) {
    return SkillGroupModel(
      category: map['category'] as String? ?? '',
      skills: (map['skills'] as List<dynamic>? ?? const [])
          .whereType<Map<dynamic, dynamic>>()
          .map((raw) => SkillModel.fromMap(Map<String, dynamic>.from(raw)))
          .toList(),
    );
  }

  factory SkillGroupModel.fromEntity(SkillGroup group) {
    return SkillGroupModel(
      category: group.category,
      skills: group.skills
          .map(
            (skill) => SkillModel(
              name: skill.name,
              level: skill.level,
              iconUrl: skill.iconUrl,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'skills': skills.cast<SkillModel>().map((s) => s.toMap()).toList(),
    };
  }

  /// Legacy flat rows (`[{name, level}]`) migrate into one untitled group.
  static List<SkillGroup> listFromJson(List<dynamic> raw) {
    if (raw.isEmpty) return const [];
    final bool nested =
        raw.first is Map && (raw.first as Map)['category'] != null;
    if (!nested) {
      final legacy = raw
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => SkillModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();
      return [SkillGroup(category: '', skills: legacy)];
    }
    return raw
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => SkillGroupModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }
}
