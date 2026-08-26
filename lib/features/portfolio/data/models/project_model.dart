import '../../domain/entities/project.dart';
import '../../domain/entities/project_category.dart';

final class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.longDescription,
    required super.techStack,
    required super.role,
    required super.imageUrls,
    required super.category,
    required super.featured,
    required super.order,
    required super.createdAt,
    required super.updatedAt,
    super.googlePlayUrl,
    super.appStoreUrl,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      longDescription: map['longDescription'] as String? ?? '',
      techStack: (map['techStack'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      role: map['role'] as String? ?? '',
      imageUrls: (map['imageUrls'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      googlePlayUrl: map['googlePlayUrl'] as String?,
      appStoreUrl: map['appStoreUrl'] as String?,
      category: ProjectCategory.fromValue(map['category'] as String? ?? ''),
      featured: map['featured'] as bool? ?? false,
      order: (map['order'] as num?)?.toInt() ?? 0,
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      title: project.title,
      description: project.description,
      longDescription: project.longDescription,
      techStack: project.techStack,
      role: project.role,
      imageUrls: project.imageUrls,
      googlePlayUrl: project.googlePlayUrl,
      appStoreUrl: project.appStoreUrl,
      category: project.category,
      featured: project.featured,
      order: project.order,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'longDescription': longDescription,
      'techStack': techStack,
      'role': role,
      'imageUrls': imageUrls,
      'googlePlayUrl': googlePlayUrl,
      'appStoreUrl': appStoreUrl,
      'category': category.value,
      'featured': featured,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static DateTime _toDateTime(dynamic value) => switch (value) {
    final String iso when iso.isNotEmpty => DateTime.tryParse(iso) ?? _epoch,
    final DateTime dateTime => dateTime,
    _ => _epoch,
  };

  static final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(0);
}
