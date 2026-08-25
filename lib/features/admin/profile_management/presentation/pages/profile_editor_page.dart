import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localizations_cubit/locale_cubit.dart';

import '../../../../../core/di/injector.dart';
import '../../../../../core/theme/app_accents.dart';
import '../../../../../core/utils/url_helper.dart';
import '../../../media/domain/repositories/media_storage_repository.dart';
import '../../../../portfolio/domain/repositories/profile_repository.dart';
import '../cubit/profile_editor_cubit.dart';
import '../cubit/profile_editor_state.dart';
import '../widgets/profile_live_preview.dart';

final class ProfileEditorPage extends StatelessWidget {
  const ProfileEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditorCubit>(
      create: (_) => ProfileEditorCubit(
        getIt<ProfileRepository>(),
        getIt<MediaStorageRepository>(),
      )..load(),
      child: const _ProfileEditorView(),
    );
  }
}

class _ProfileEditorView extends StatelessWidget {
  const _ProfileEditorView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileEditorCubit, ProfileEditorState>(
      listener: (context, state) {
        final String? error = state.errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            );
          context.read<ProfileEditorCubit>().dismissError();
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case ProfileEditorStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProfileEditorStatus.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? context.loc.profileFailedToLoad),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => context.read<ProfileEditorCubit>().load(),
                    child: Text(context.loc.commonRetry),
                  ),
                ],
              ),
            );
          case ProfileEditorStatus.ready:
            return _EditorScaffold(state: state);
        }
      },
    );
  }
}

class _EditorScaffold extends StatelessWidget {
  const _EditorScaffold({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = MediaQuery.sizeOf(context).width < 980;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.loc.profileEditorTitle,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              if (state.isDirty)
                FilledButton.icon(
                  onPressed: state.isBusy
                      ? null
                      : () => context.read<ProfileEditorCubit>().save(),
                  icon: state.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(
                    state.isSaving
                        ? context.loc.profileSaving
                        : context.loc.profileSaveChanges,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Flex(
                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _FormColumn(state: state)),
                    if (!isCompact) const SizedBox(width: 28),
                    Expanded(
                      flex: 2,
                      child: ProfileLivePreview(profile: state.profile),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// The form column and shared inputs live in `_form_column`-style widgets below.
class _FormColumn extends StatelessWidget {
  const _FormColumn({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BasicsCard(state: state),
        const SizedBox(height: 18),
        _SkillsCard(state: state),
        const SizedBox(height: 18),
        _MediaCard(state: state),
        const SizedBox(height: 18),
        _SocialLinksCard(state: state),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProfileEditorCubit>();
    final skills = state.profile.skills;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.loc.skillsHeading,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: cubit.addSkill,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(context.loc.skillsAdd),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (skills.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  context.loc.skillsEmpty,
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              for (var i = 0; i < skills.length; i++)
                Row(
                  key: ValueKey('skill-row-$i-${skills[i].name}'),
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: skills[i].name.isEmpty
                            ? null
                            : skills[i].name,
                        onChanged: (value) => cubit.renameSkill(i, value),
                        decoration: InputDecoration(
                          labelText: loc.skillLabel(i + 1),
                          isDense: true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        value: skills[i].level.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '${skills[i].level}',
                        onChanged: (value) => cubit.setSkillLevel(i, value),
                      ),
                    ),
                    Text(
                      '${skills[i].level}%',
                      style: theme.textTheme.labelMedium,
                    ),
                    IconButton(
                      tooltip: context.loc.commonRemove,
                      onPressed: () => cubit.removeSkill(i),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 19,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class _BasicsCard extends StatelessWidget {
  const _BasicsCard({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final cubit = context.read<ProfileEditorCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.profileBasicsHeading,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: state.profile.name,
              onChanged: cubit.setName,
              decoration: InputDecoration(labelText: loc.fieldName),
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: state.profile.title,
              onChanged: cubit.setTitle,
              decoration: InputDecoration(labelText: loc.fieldTitle),
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: state.profile.tagline,
              onChanged: cubit.setTagline,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: loc.fieldTagline,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('years-${state.profile.yearsOfExperience}'),
              initialValue: '${state.profile.yearsOfExperience}',
              onChanged: cubit.setYearsOfExperience,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.fieldYearsOfExperience,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.availableSwitchTitle),
              subtitle: Text(loc.availableSwitchSubtitle),
              value: state.profile.availableForWork,
              onChanged: (value) => cubit.setAvailableForWork(available: value),
            ),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: state.profile.aboutMe,
              onChanged: cubit.setAboutMe,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: loc.fieldAboutMe,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProfileEditorCubit>();
    final photoUrl = state.profile.profileImageUrl;
    final resumeUrl = state.profile.resumeUrl;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Photo & resume', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: context.accents.accentGradient,
                    image: photoUrl != null && photoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: state.isUploadingImage
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : (photoUrl == null || photoUrl.isEmpty)
                      ? Icon(
                          Icons.person_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 34,
                        )
                      : null,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: state.isBusy
                            ? null
                            : cubit.pickAndUploadPhoto,
                        icon: const Icon(Icons.upload_rounded, size: 18),
                        label: const Text('Upload photo'),
                      ),
                      if (photoUrl != null && photoUrl.isNotEmpty)
                        TextButton.icon(
                          onPressed: state.isBusy ? null : cubit.clearPhoto,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Remove'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    resumeUrl == null || resumeUrl.isEmpty
                        ? 'No resume uploaded yet.'
                        : 'Resume uploaded ✓',
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: state.isBusy ? null : cubit.pickAndUploadResume,
                  icon: state.isUploadingResume
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: Text(
                    resumeUrl == null || resumeUrl.isEmpty
                        ? 'Upload PDF'
                        : 'Replace PDF',
                  ),
                ),
                if (resumeUrl != null && resumeUrl.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Open resume',
                    onPressed: () => openExternalUrl(resumeUrl),
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLinksCard extends StatelessWidget {
  const _SocialLinksCard({required this.state});

  final ProfileEditorState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileEditorCubit>();
    final links = state.profile.socialLinks;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Social links', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('github'),
              initialValue: links.github,
              onChanged: (value) =>
                  cubit.setSocialLink(SocialField.github, value),
              decoration: const InputDecoration(labelText: 'GitHub URL'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('linkedin'),
              initialValue: links.linkedin,
              onChanged: (value) =>
                  cubit.setSocialLink(SocialField.linkedin, value),
              decoration: const InputDecoration(labelText: 'LinkedIn URL'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('twitter'),
              initialValue: links.twitter,
              onChanged: (value) =>
                  cubit.setSocialLink(SocialField.twitter, value),
              decoration: const InputDecoration(labelText: 'Twitter / X URL'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('email'),
              initialValue: links.email,
              onChanged: (value) =>
                  cubit.setSocialLink(SocialField.email, value),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Contact email',
                helperText: 'Also used by the contact form',
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('whatsapp'),
              initialValue: links.whatsapp,
              onChanged: (value) =>
                  cubit.setSocialLink(SocialField.whatsapp, value),
              decoration: const InputDecoration(
                labelText: 'WhatsApp link',
                helperText: 'e.g. https://wa.me/1234567890',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
