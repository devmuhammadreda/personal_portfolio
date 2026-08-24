import 'package:equatable/equatable.dart';

import 'project_category.dart';

class Project extends Equatable {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.techStack,
    required this.role,
    required this.imageUrls,
    required this.category,
    required this.featured,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.liveUrl,
    this.githubUrl,
  });

  /// Firestore document id. Empty for a not-yet-persisted project.
  final String id;
  final String title;
  final String description;
  final String longDescription;
  final List<String> techStack;
  final String role;
  final List<String> imageUrls;
  final String? liveUrl;
  final String? githubUrl;
  final ProjectCategory category;
  final bool featured;

  /// Manual sort position (lower renders first).
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isNew => id.isEmpty;

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? longDescription,
    List<String>? techStack,
    String? role,
    List<String>? imageUrls,
    String? liveUrl,
    bool clearLiveUrl = false,
    String? githubUrl,
    bool clearGithubUrl = false,
    ProjectCategory? category,
    bool? featured,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      longDescription: longDescription ?? this.longDescription,
      techStack: techStack ?? this.techStack,
      role: role ?? this.role,
      imageUrls: imageUrls ?? this.imageUrls,
      liveUrl: clearLiveUrl ? null : (liveUrl ?? this.liveUrl),
      githubUrl: clearGithubUrl ? null : (githubUrl ?? this.githubUrl),
      category: category ?? this.category,
      featured: featured ?? this.featured,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    longDescription,
    techStack,
    role,
    imageUrls,
    liveUrl,
    githubUrl,
    category,
    featured,
    order,
    createdAt,
    updatedAt,
  ];
}
