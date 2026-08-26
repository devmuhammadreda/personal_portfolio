import '../../domain/entities/profile.dart';
import 'skill_group_model.dart';
import 'skill_model.dart';
import 'social_links_model.dart';

final class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.title,
    required super.tagline,
    required super.aboutMe,
    required super.skillGroups,
    required super.socialLinks,
    required super.yearsOfExperience,
    required super.availableForWork,
    super.resumeUrl,
    super.profileImageUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] as String? ?? '',
      title: map['title'] as String? ?? '',
      tagline: map['tagline'] as String? ?? '',
      aboutMe: map['aboutMe'] as String? ?? '',
      skillGroups: SkillGroupModel.listFromJson(
        map['skills'] as List<dynamic>? ?? const [],
      ),
      socialLinks: SocialLinksModel.fromMap(
        Map<String, dynamic>.from(map['socialLinks'] as Map? ?? const {}),
      ),
      resumeUrl: map['resumeUrl'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      yearsOfExperience: (map['yearsOfExperience'] as num?)?.toInt() ?? 0,
      availableForWork: map['availableForWork'] as bool? ?? false,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      name: profile.name,
      title: profile.title,
      tagline: profile.tagline,
      aboutMe: profile.aboutMe,
      skillGroups: profile.skillGroups
          .map(
            (group) => SkillGroupModel(
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
            ),
          )
          .toList(),
      socialLinks: SocialLinksModel(
        github: profile.socialLinks.github,
        linkedin: profile.socialLinks.linkedin,
        twitter: profile.socialLinks.twitter,
        email: profile.socialLinks.email,
        whatsapp: profile.socialLinks.whatsapp,
      ),
      resumeUrl: profile.resumeUrl,
      profileImageUrl: profile.profileImageUrl,
      yearsOfExperience: profile.yearsOfExperience,
      availableForWork: profile.availableForWork,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'title': title,
      'tagline': tagline,
      'aboutMe': aboutMe,
      'skills': skillGroups
          .cast<SkillGroupModel>()
          .map((g) => g.toMap())
          .toList(),
      'socialLinks': (socialLinks as SocialLinksModel).toMap(),
      if (resumeUrl != null) 'resumeUrl': resumeUrl,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'yearsOfExperience': yearsOfExperience,
      'availableForWork': availableForWork,
    };
  }
}
