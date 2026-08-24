import 'package:equatable/equatable.dart';

class SocialLinks extends Equatable {
  const SocialLinks({
    this.github,
    this.linkedin,
    this.twitter,
    this.email,
    this.whatsapp,
  });

  final String? github;
  final String? linkedin;
  final String? twitter;
  final String? email;
  final String? whatsapp;

  static const SocialLinks empty = SocialLinks();

  /// Ordered (label, url) pairs, skipping unset links.
  List<(String, String)> get entries => [
    if (github case final v?) ('GitHub', v),
    if (linkedin case final v?) ('LinkedIn', v),
    if (twitter case final v?) ('Twitter / X', v),
    if (email case final v?) ('Email', 'mailto:$v'),
    if (whatsapp case final v?) ('WhatsApp', v),
  ];

  @override
  List<Object?> get props => [github, linkedin, twitter, email, whatsapp];
}
