import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/url_helper.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'floating_particles_background.dart';

final class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
  });

  final VoidCallback onViewWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final bool isCompact = MediaQuery.sizeOf(context).width < 900;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) => previous.profile != current.profile,
      builder: (context, state) {
        final profile = state.profile;
        return Stack(
          fit: StackFit.expand,
          children: [
            const FloatingParticlesBackground(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isCompact
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      if (profile.availableForWork)
                        _AvailabilityBadge()
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: -0.6,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                      const SizedBox(height: 22),
                      Text(
                            'Hi there, I\u2019m',
                            style: textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                          .animate(delay: 150.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(
                            begin: 0.4,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 10),
                      _GradientText(
                            text: profile.name.isEmpty
                                ? 'Flutter Developer'
                                : profile.name,
                            style: isCompact
                                ? textTheme.displayMedium
                                : textTheme.displayLarge,
                          )
                          .animate(delay: 250.ms)
                          .fadeIn(duration: 700.ms)
                          .slideY(
                            begin: 0.35,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 12),
                      Text(
                        profile.title.isEmpty
                            ? 'Building beautiful apps, one widget at a time'
                            : profile.title,
                        style: isCompact
                            ? textTheme.headlineSmall
                            : textTheme.headlineMedium,
                        textAlign: isCompact
                            ? TextAlign.center
                            : TextAlign.start,
                      ).animate(delay: 350.ms).fadeIn(duration: 700.ms),
                      if (profile.tagline.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Text(
                            profile.tagline,
                            style: textTheme.bodyLarge,
                            textAlign: isCompact
                                ? TextAlign.center
                                : TextAlign.start,
                          ),
                        ).animate(delay: 450.ms).fadeIn(duration: 700.ms),
                      ],
                      const SizedBox(height: 36),
                      Wrap(
                            spacing: 14,
                            runSpacing: 12,
                            alignment: isCompact
                                ? WrapAlignment.center
                                : WrapAlignment.start,
                            children: [
                              FilledButton.icon(
                                onPressed: onViewWork,
                                icon: const Icon(
                                  Icons.work_outline_rounded,
                                  size: 19,
                                ),
                                label: const Text('View My Work'),
                              ),
                              OutlinedButton.icon(
                                onPressed:
                                    profile.resumeUrl == null ||
                                        profile.resumeUrl!.isEmpty
                                    ? null
                                    : () => openExternalUrl(profile.resumeUrl!),
                                icon: const Icon(
                                  Icons.download_rounded,
                                  size: 19,
                                ),
                                label: const Text('Download CV'),
                              ),
                              TextButton.icon(
                                onPressed: onContact,
                                icon: const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 19,
                                ),
                                label: const Text('Contact Me'),
                              ),
                            ],
                          )
                          .animate(delay: 550.ms)
                          .fadeIn(duration: 650.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 26,
              left: 0,
              right: 0,
              child: Center(
                child:
                    Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                          size: 30,
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .slideY(
                          begin: 0,
                          end: 0.35,
                          duration: 1100.ms,
                          curve: Curves.easeInOut,
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppPalette.accentGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.green.withValues(alpha: 0.12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.shade400,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeOut(duration: 900.ms, curve: Curves.easeInOut),
          const SizedBox(width: 8),
          Text(
            'Available for work',
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: Colors.green.shade300),
          ),
        ],
      ),
    );
  }
}
