import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../domain/entities/education.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_category.dart';
import '../../domain/entities/work_experience.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/timeline_repository.dart';
import 'portfolio_state.dart';

final class PortfolioCubit extends Cubit<PortfolioState>
    with CubitLifecycleMixin<PortfolioState> {
  PortfolioCubit({
    required this._profileRepository,
    required this._projectRepository,
    required this._timelineRepository,
  }) : super(const PortfolioState());

  final ProfileRepository _profileRepository;
  final ProjectRepository _projectRepository;
  final TimelineRepository _timelineRepository;

  Future<void> load() async {
    if (state.isLoading) return;
    safeEmit(state.copyWith(status: PortfolioStatus.loading, clearError: true));
    try {
      final results = await Future.wait<dynamic>([
        _profileRepository.getProfile(),
        _projectRepository.getProjects(),
        _timelineRepository.getWorkExperience(),
        _timelineRepository.getEducation(),
      ]);
      final Profile profile = results[0] as Profile;
      final List<Project> projects = (results[1] as List<Project>)
        ..sort((a, b) => a.order.compareTo(b.order));
      final List<WorkExperience> experiences =
          (results[2] as List<WorkExperience>)
            ..sort((a, b) => a.order.compareTo(b.order));
      final List<Education> educations = (results[3] as List<Education>)
        ..sort((a, b) => a.order.compareTo(b.order));
      safeEmit(
        state.copyWith(
          status: PortfolioStatus.ready,
          profile: profile,
          projects: projects,
          experiences: experiences,
          educations: educations,
        ),
      );
    } on AppFailure catch (error) {
      safeEmit(
        state.copyWith(
          status: PortfolioStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      // Unknown failures stay unlabelled; the UI shows a localized
      // generic message.
      safeEmit(state.copyWith(status: PortfolioStatus.failure));
    }
  }

  void selectCategory(ProjectCategory? category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        clearSelectedCategory: category == null,
      ),
    );
  }
}
