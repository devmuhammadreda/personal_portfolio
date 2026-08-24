import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/url_helper.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'section_header.dart';

final class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final String? email = context
        .read<PortfolioCubit>()
        .state
        .profile
        .socialLinks
        .email;
    if (email == null || email.isEmpty) return;

    setState(() => _sending = true);
    try {
      await composeEmail(
        to: email,
        subject: 'Portfolio contact from ${_name.text.trim()}',
        body:
            '${_message.text.trim()}\n\n— ${_name.text.trim()} (${_email.text.trim()})',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opening your mail app…')));
      _formKey.currentState?.reset();
      _name.clear();
      _email.clear();
      _message.clear();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.isCompact;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      buildWhen: (previous, current) => previous.profile != current.profile,
      builder: (context, state) {
        final socialLinks = state.profile.socialLinks;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(index: '03', title: 'Contact'),
            const SizedBox(height: 28),
            Flex(
              direction: isCompact ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: isCompact
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                            'Let\u2019s build something together.',
                            style: theme.textTheme.headlineSmall,
                            textAlign: isCompact
                                ? TextAlign.center
                                : TextAlign.start,
                          )
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      const SizedBox(height: 14),
                      Text(
                        'Have a project in mind or just want to say hi? '
                        'My inbox is always open.',
                        style: theme.textTheme.bodyLarge,
                        textAlign: isCompact
                            ? TextAlign.center
                            : TextAlign.start,
                      ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
                      const SizedBox(height: 26),
                      Wrap(
                        alignment: isCompact
                            ? WrapAlignment.center
                            : WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final (label, url) in socialLinks.entries)
                            _SocialButton(label: label, url: url),
                        ],
                      ).animate(delay: 300.ms).fadeIn(duration: 600.ms),
                    ],
                  ),
                ),
                if (!isCompact) const SizedBox(width: 56),
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _name,
                              decoration: const InputDecoration(
                                labelText: 'Your name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter your name.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Your email',
                                prefixIcon: Icon(Icons.alternate_email_rounded),
                              ),
                              validator: (value) =>
                                  value == null ||
                                      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                          .hasMatch(value)
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _message,
                              maxLines: 5,
                              minLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Message',
                                alignLabelWithHint: true,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().length < 10
                                  ? 'Tell me a bit more (min. 10 characters).'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: _sending ? null : _send,
                              icon: _sending
                                  ? const SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded, size: 18),
                              label: Text(
                                _sending ? 'Opening…' : 'Send message',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({required this.label, required this.url});

  final String label;
  final String url;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovering = false;

  IconData get _icon => switch (widget.label.toLowerCase()) {
    'github' => Icons.code_rounded,
    'linkedin' => Icons.business_center_outlined,
    'twitter / x' => Icons.alternate_email_rounded,
    'email' => Icons.mail_outline_rounded,
    'whatsapp' => Icons.chat_bubble_outline_rounded,
    _ => Icons.link_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => openExternalUrl(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          transformAlignment: Alignment.center,
          transform: Matrix4.translationValues(0, _hovering ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: _hovering
                ? scheme.primary.withValues(alpha: 0.12)
                : scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovering ? scheme.primary : scheme.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  _icon,
                  key: ValueKey<bool>(_hovering),
                  size: 18,
                  color: _hovering ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 9),
              Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
