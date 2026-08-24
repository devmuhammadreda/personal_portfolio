import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/di/injector.dart';
import '../../../../portfolio/domain/entities/project_category.dart';
import '../../../../portfolio/domain/repositories/project_repository.dart';
import '../../../media/domain/repositories/media_storage_repository.dart';
import '../cubit/project_form_cubit.dart';
import '../cubit/project_form_state.dart';

final class ProjectFormPage extends StatelessWidget {
  const ProjectFormPage({super.key, this.projectId});

  final String? projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectFormCubit>(
      create: (_) => ProjectFormCubit(
        getIt<ProjectRepository>(),
        getIt<MediaStorageRepository>(),
      )..init(projectId: projectId),
      child: const _ProjectFormView(),
    );
  }
}

class _ProjectFormView extends StatelessWidget {
  const _ProjectFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectFormCubit, ProjectFormState>(
      listener: (context, state) {
        final String? error = state.errorMessage;
        if (error != null && state.status != ProjectFormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error)));
          context.read<ProjectFormCubit>().dismissError();
          return;
        }
        if (state.status == ProjectFormStatus.failure && error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        }
        if (state.status == ProjectFormStatus.saved) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Project saved ✓')));
          context.go(AppRoutes.adminProjects);
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case ProjectFormStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProjectFormStatus.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Failed to load project.'),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => context.go(AppRoutes.adminProjects),
                    child: const Text('Back to projects'),
                  ),
                ],
              ),
            );
          case ProjectFormStatus.ready:
          case ProjectFormStatus.saving:
          case ProjectFormStatus.saved:
            if (state.project == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return _FormBody(state: state);
        }
      },
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({required this.state});

  final ProjectFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProjectFormCubit>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.isNew ? 'New project' : 'Edit project',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _BasicsSection(state: state),
                const SizedBox(height: 18),
                _ImagesSection(state: state),
                const SizedBox(height: 18),
                _LinksSection(state: state),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go(AppRoutes.adminProjects),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: state.isBusy ? null : () => cubit.save(),
                      icon: state.status == ProjectFormStatus.saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_rounded, size: 18),
                      label: Text(
                        state.status == ProjectFormStatus.saving
                            ? 'Saving…'
                            : 'Save project',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicsSection extends StatelessWidget {
  const _BasicsSection({required this.state});

  final ProjectFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProjectFormCubit>();
    final project = state.project!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basics', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              key: ValueKey('title-${project.id}'),
              initialValue: project.title.isEmpty ? null : project.title,
              onChanged: cubit.setTitle,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Title is required.'
                  : null,
              decoration: const InputDecoration(labelText: 'Title *'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<ProjectCategory>(
                    key: ValueKey(
                      'category-${project.id}-${project.category.name}',
                    ),
                    initialValue: project.category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      for (final category in ProjectCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) cubit.setCategory(value);
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: ValueKey('role-${project.id}'),
                    initialValue: project.role.isEmpty ? null : project.role,
                    onChanged: cubit.setRole,
                    decoration: const InputDecoration(labelText: 'Your role'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('description-${project.id}'),
              initialValue: project.description.isEmpty
                  ? null
                  : project.description,
              onChanged: cubit.setDescription,
              maxLines: 2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Short description is required.'
                  : null,
              decoration: const InputDecoration(
                labelText: 'Short description *',
                helperText: 'Shown on the project card',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('long-${project.id}'),
              initialValue: project.longDescription.isEmpty
                  ? null
                  : project.longDescription,
              onChanged: cubit.setLongDescription,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Full description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Featured project'),
              subtitle: const Text('Highlights it on cards and the dashboard'),
              value: project.featured,
              onChanged: (value) => cubit.setFeatured(featured: value),
            ),
            const SizedBox(height: 8),
            _TechStackField(state: state),
          ],
        ),
      ),
    );
  }
}

class _TechStackField extends StatefulWidget {
  const _TechStackField({required this.state});

  final ProjectFormState state;

  @override
  State<_TechStackField> createState() => _TechStackFieldState();
}

class _TechStackFieldState extends State<_TechStackField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    context.read<ProjectFormCubit>().addTech(_controller.text);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final techStack = widget.state.project!.techStack;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Tech stack',
            helperText: 'Type a technology and press Add',
            suffixIcon: IconButton(
              tooltip: 'Add',
              onPressed: _add,
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          onSubmitted: (_) => _add(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < techStack.length; i++)
              InputChip(
                label: Text(techStack[i], style: theme.textTheme.labelMedium),
                onDeleted: () =>
                    context.read<ProjectFormCubit>().removeTechAt(i),
              ),
            if (techStack.isEmpty)
              Text(
                'No technologies added yet.',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ],
    );
  }
}

class _ImagesSection extends StatelessWidget {
  const _ImagesSection({required this.state});

  final ProjectFormState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cubit = context.read<ProjectFormCubit>();
    final images = state.project!.imageUrls;

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
                    'Screenshots (${images.length})',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: state.isBusy ? null : cubit.addImages,
                  icon: state.isUploadingImages
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_rounded, size: 18),
                  label: Text(
                    state.isUploadingImages ? 'Uploading…' : 'Add images',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'The first image is used as the card cover.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            if (images.isEmpty && !state.isUploadingImages)
              Text('No screenshots yet.', style: theme.textTheme.bodyMedium)
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < images.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            images[i],
                            width: 168,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 168,
                              height: 96,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => cubit.removeImageAt(i),
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.65),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (i == 0)
                          Positioned(
                            bottom: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                              child: Text(
                                'Cover',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LinksSection extends StatelessWidget {
  const _LinksSection({required this.state});

  final ProjectFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectFormCubit>();
    final project = state.project!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Links', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              key: ValueKey('live-${project.id}'),
              initialValue: project.liveUrl,
              onChanged: cubit.setLiveUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Live demo URL'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: ValueKey('github-${project.id}'),
              initialValue: project.githubUrl,
              onChanged: cubit.setGithubUrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'GitHub repository URL',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
