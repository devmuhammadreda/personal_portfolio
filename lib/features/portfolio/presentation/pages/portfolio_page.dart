import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../core/utils/responsive.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import '../widgets/about_section.dart';
import '../widgets/animated_navbar.dart';
import '../widgets/contact_section.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/site_footer.dart';
import '../widgets/scroll_reveal.dart';

final class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, this.footerTrailing});

  /// Optional extra footer item (e.g. the admin-flavor shortcut chip).
  final Widget? footerTrailing;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final BuildContext? targetContext = key.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PortfolioCubit>(
      create: (_) => PortfolioCubit(
        profileRepository: getIt(),
        projectRepository: getIt(),
        timelineRepository: getIt(),
      )..load(),
      child: BlocConsumer<PortfolioCubit, PortfolioState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading || state.status == PortfolioStatus.initial) {
            return const _LoadingView();
          }
          if (state.hasError) {
            return _ErrorView(
              message: state.errorMessage,
              onRetry: () => context.read<PortfolioCubit>().load(),
            );
          }
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: ScrollRevealScope(
                    scrollController: _scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                          key: _heroKey,
                          height: MediaQuery.sizeOf(context).height,
                          width: double.infinity,
                          child: HeroSection(
                            onViewWork: () => _scrollTo(_projectsKey),
                            onContact: () => _scrollTo(_contactKey),
                          ),
                        ),
                        Container(
                          key: _aboutKey,
                          padding: context.sectionPadding,
                          constraints: BoxConstraints(
                            maxWidth: context.contentMaxWidth + 96,
                          ),
                          child: const AboutSection(),
                        ),
                        Container(
                          key: _experienceKey,
                          padding: context.sectionPadding,
                          constraints: BoxConstraints(
                            maxWidth: context.contentMaxWidth + 96,
                          ),
                          child: const ExperienceSection(),
                        ),
                        Container(
                          key: _educationKey,
                          padding: context.sectionPadding,
                          constraints: BoxConstraints(
                            maxWidth: context.contentMaxWidth + 96,
                          ),
                          child: const EducationSection(),
                        ),
                        Container(
                          key: _projectsKey,
                          padding: context.sectionPadding,
                          constraints: BoxConstraints(
                            maxWidth: context.contentMaxWidth + 96,
                          ),
                          child: const ProjectsSection(),
                        ),
                        Container(
                          key: _contactKey,
                          padding: context.sectionPadding,
                          constraints: BoxConstraints(
                            maxWidth: context.contentMaxWidth + 96,
                          ),
                          child: const ContactSection(),
                        ),
                        SiteFooter(trailing: widget.footerTrailing),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: AnimatedNavbar(
                      scrollController: _scrollController,
                      title: state.profile.name.isEmpty
                          ? 'dev.portfolio'
                          : state.profile.name.split(' ').first.toLowerCase(),
                      onTitleTap: () => _scrollTo(_heroKey),
                      sections: [
                        (context.loc.navAbout, () => _scrollTo(_aboutKey)),
                        (
                          context.loc.navExperience,
                          () => _scrollTo(_experienceKey),
                        ),
                        (
                          context.loc.navEducation,
                          () => _scrollTo(_educationKey),
                        ),
                        (
                          context.loc.navProjects,
                          () => _scrollTo(_projectsKey),
                        ),
                        (context.loc.navContact, () => _scrollTo(_contactKey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              context.loc.loadingPortfolio,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 46,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  message ?? context.loc.errorLoadingPortfolio,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 19),
                  label: Text(context.loc.commonRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
