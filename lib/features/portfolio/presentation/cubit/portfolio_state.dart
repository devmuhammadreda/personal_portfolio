import 'package:equatable/equatable.dart';

import '../../domain/entities/education.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_category.dart';
import '../../domain/entities/work_experience.dart';

enum PortfolioStatus { initial, loading, ready, failure }

final class PortfolioState extends Equatable {
  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.profile = Profile.empty,
    this.projects = const [],
    this.experiences = const [],
    this.educations = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  final PortfolioStatus status;
  final Profile profile;
  final List<Project> projects;
  final List<WorkExperience> experiences;
  final List<Education> educations;
  final ProjectCategory? selectedCategory;
  final String? errorMessage;

  bool get isLoading => status == PortfolioStatus.loading;

  bool get hasError => status == PortfolioStatus.failure;

  List<Project> get filteredProjects {
    final ProjectCategory? category = selectedCategory;
    if (category == null) return projects;
    return projects.where((project) => project.category == category).toList();
  }

  PortfolioState copyWith({
    PortfolioStatus? status,
    Profile? profile,
    List<Project>? projects,
    List<WorkExperience>? experiences,
    List<Education>? educations,
    ProjectCategory? selectedCategory,
    bool clearSelectedCategory = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      projects: projects ?? this.projects,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    projects,
    experiences,
    educations,
    selectedCategory,
    errorMessage,
  ];
}
