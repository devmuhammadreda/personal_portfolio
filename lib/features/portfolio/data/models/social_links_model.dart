import '../../domain/entities/social_links.dart';

final class SocialLinksModel extends SocialLinks {
  const SocialLinksModel({
    super.github,
    super.linkedin,
    super.twitter,
    super.email,
    super.whatsapp,
  });

  factory SocialLinksModel.fromMap(Map<String, dynamic> map) {
    return SocialLinksModel(
      github: map['github'] as String?,
      linkedin: map['linkedin'] as String?,
      twitter: map['twitter'] as String?,
      email: map['email'] as String?,
      whatsapp: map['whatsapp'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (github != null && github!.isNotEmpty) 'github': github,
      if (linkedin != null && linkedin!.isNotEmpty) 'linkedin': linkedin,
      if (twitter != null && twitter!.isNotEmpty) 'twitter': twitter,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (whatsapp != null && whatsapp!.isNotEmpty) 'whatsapp': whatsapp,
    };
  }
}
