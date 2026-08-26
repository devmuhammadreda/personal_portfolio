import 'package:equatable/equatable.dart';

import 'skill.dart';
import 'skill_group.dart';
import 'social_links.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.title,
    required this.tagline,
    required this.aboutMe,
    required this.skillGroups,
    required this.socialLinks,
    required this.yearsOfExperience,
    required this.availableForWork,
    this.resumeUrl,
    this.profileImageUrl,
  });

  final String name;
  final String title;
  final String tagline;
  final String aboutMe;
  final List<SkillGroup> skillGroups;
  final SocialLinks socialLinks;
  final String? resumeUrl;
  final String? profileImageUrl;
  final int yearsOfExperience;
  final bool availableForWork;

  /// Total number of individual skills across all groups.
  int get totalSkills =>
      skillGroups.fold(0, (count, group) => count + group.skills.length);

  /// All skills flattened, preserving group order.
  Iterable<Skill> get allSkills sync* {
    for (final group in skillGroups) {
      yield* group.skills;
    }
  }

  static const Profile empty = Profile(
    name: '',
    title: '',
    tagline: '',
    aboutMe: '',
    skillGroups: [],
    socialLinks: SocialLinks.empty,
    yearsOfExperience: 0,
    availableForWork: false,
  );

  bool get isEmpty => this == empty;

  Profile copyWith({
    String? name,
    String? title,
    String? tagline,
    String? aboutMe,
    List<SkillGroup>? skillGroups,
    SocialLinks? socialLinks,
    String? resumeUrl,
    bool clearResumeUrl = false,
    String? profileImageUrl,
    bool clearProfileImageUrl = false,
    int? yearsOfExperience,
    bool? availableForWork,
  }) {
    return Profile(
      name: name ?? this.name,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      aboutMe: aboutMe ?? this.aboutMe,
      skillGroups: skillGroups ?? this.skillGroups,
      socialLinks: socialLinks ?? this.socialLinks,
      resumeUrl: clearResumeUrl ? null : (resumeUrl ?? this.resumeUrl),
      profileImageUrl: clearProfileImageUrl
          ? null
          : (profileImageUrl ?? this.profileImageUrl),
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      availableForWork: availableForWork ?? this.availableForWork,
    );
  }

  @override
  List<Object?> get props => [
    name,
    title,
    tagline,
    aboutMe,
    skillGroups,
    socialLinks,
    resumeUrl,
    profileImageUrl,
    yearsOfExperience,
    availableForWork,
  ];
}
