import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../portfolio/domain/entities/profile.dart';

/// Right-hand preview card in the profile editor, mirroring the public
/// hero styling so edits read exactly as they will render.
final class ProfileLivePreview extends StatelessWidget {
  const ProfileLivePreview({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final photoUrl = profile.profileImageUrl;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview_rounded, size: 18, color: scheme.secondary),
                const SizedBox(width: 8),
                Text('Live preview', style: theme.textTheme.labelLarge),
                const Spacer(),
                Text('updates as you type', style: theme.textTheme.labelMedium),
              ],
            ),
            const Divider(height: 30),
            Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppPalette.accentGradient,
                  border: Border.all(color: scheme.outline),
                  image: photoUrl != null && photoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(photoUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: photoUrl == null || photoUrl.isEmpty
                    ? Icon(
                        Icons.person_outline_rounded,
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.9),
                      )
                    : null,
              ),
            ),
            if (profile.availableForWork) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.green.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    'Available for work',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.green.shade300,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    AppPalette.accentGradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  profile.name.isEmpty ? 'Your name' : profile.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                profile.title.isEmpty ? 'Your title' : profile.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (profile.tagline.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                profile.tagline,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const Divider(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in profile.skills.take(6))
                  Chip(
                    label: Text(skill.name),
                    visualDensity: VisualDensity.compact,
                  ),
                if (profile.skills.isEmpty)
                  Text(
                    'No skills yet — add some below.',
                    style: theme.textTheme.bodyMedium,
                  ),
              ],
            ),
            if (profile.skills.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${profile.skills.length} skills configured',
                  style: theme.textTheme.labelMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
