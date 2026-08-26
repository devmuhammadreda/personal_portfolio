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
    this.googlePlayUrl,
    this.appStoreUrl,
  });

  /// Firestore document id. Empty for a not-yet-persisted project.
  final String id;
  final String title;
  final String description;
  final String longDescription;
  final List<String> techStack;
  final String role;
  final List<String> imageUrls;

  /// Production store links.
  final String? googlePlayUrl;
  final String? appStoreUrl;
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
    String? googlePlayUrl,
    bool clearGooglePlayUrl = false,
    String? appStoreUrl,
    bool clearAppStoreUrl = false,
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
      googlePlayUrl: clearGooglePlayUrl
          ? null
          : (googlePlayUrl ?? this.googlePlayUrl),
      appStoreUrl: clearAppStoreUrl ? null : (appStoreUrl ?? this.appStoreUrl),
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
    googlePlayUrl,
    appStoreUrl,
    category,
    featured,
    order,
    createdAt,
    updatedAt,
  ];
}
