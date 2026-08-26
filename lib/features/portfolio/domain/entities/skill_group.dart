import 'package:equatable/equatable.dart';

import 'skill.dart';

/// A named category bundling related [Skill]s, e.g.
/// "Mobile" → Flutter / Dart / Kotlin.
class SkillGroup extends Equatable {
  const SkillGroup({required this.category, required this.skills});

  final String category;
  final List<Skill> skills;

  /// Legacy flat skills (stored before grouping) parse into a single
  /// group with an empty category; the UI hides the heading then.
  bool get hasTitle => category.isNotEmpty;

  static const SkillGroup empty = SkillGroup(category: '', skills: []);

  SkillGroup copyWith({String? category, List<Skill>? skills}) {
    return SkillGroup(
      category: category ?? this.category,
      skills: skills ?? this.skills,
    );
  }

  @override
  List<Object?> get props => [category, skills];
}
