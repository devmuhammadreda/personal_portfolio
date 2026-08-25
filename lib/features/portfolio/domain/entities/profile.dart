import 'package:equatable/equatable.dart';

import 'skill.dart';
import 'social_links.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.title,
    required this.tagline,
    required this.aboutMe,
    required this.skills,
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
  final List<Skill> skills;
  final SocialLinks socialLinks;
  final String? resumeUrl;
  final String? profileImageUrl;
  final int yearsOfExperience;
  final bool availableForWork;

  static const Profile empty = Profile(
    name: '',
    title: '',
    tagline: '',
    aboutMe: '',
    skills: [],
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
    List<Skill>? skills,
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
      skills: skills ?? this.skills,
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
    skills,
    socialLinks,
    resumeUrl,
    profileImageUrl,
    yearsOfExperience,
    availableForWork,
  ];
}
