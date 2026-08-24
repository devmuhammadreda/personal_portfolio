import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_category.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/project_repository.dart';
import 'portfolio_state.dart';

final class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit({
    required this._profileRepository,
    required this._projectRepository,
  }) : super(const PortfolioState());

  final ProfileRepository _profileRepository;
  final ProjectRepository _projectRepository;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(status: PortfolioStatus.loading, clearError: true));
    try {
      final results = await Future.wait<dynamic>([
        _profileRepository.getProfile(),
        _projectRepository.getProjects(),
      ]);
      final Profile profile = results[0] as Profile;
      final List<Project> projects = (results[1] as List<Project>)
        ..sort((a, b) => a.order.compareTo(b.order));
      emit(
        state.copyWith(
          status: PortfolioStatus.ready,
          profile: profile,
          projects: projects,
        ),
      );
    } on AppFailure catch (error) {
      emit(
        state.copyWith(
          status: PortfolioStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PortfolioStatus.failure,
          errorMessage: 'Something went wrong while loading the portfolio.',
        ),
      );
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
