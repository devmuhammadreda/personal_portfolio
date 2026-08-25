import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injector.dart';
import '../../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../../core/utils/url_helper.dart';
import '../../../../portfolio/domain/entities/contact_message.dart';
import '../../../../portfolio/domain/repositories/contact_message_repository.dart';
import '../cubit/messages_admin_cubit.dart';
import '../cubit/messages_admin_state.dart';

final class MessagesAdminPage extends StatelessWidget {
  const MessagesAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagesAdminCubit>(
      create: (_) =>
          MessagesAdminCubit(getIt<ContactMessageRepository>())..load(),
      child: BlocConsumer<MessagesAdminCubit, MessagesAdminState>(
        listener: (context, state) {
          final String? error = state.errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error)));
            context.read<MessagesAdminCubit>().dismissError();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case MessagesAdminStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case MessagesAdminStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ??
                          context.loc.messagesAdminFailedToLoad,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.read<MessagesAdminCubit>().load(),
                      child: Text(context.loc.commonRetry),
                    ),
                  ],
                ),
              );
            case MessagesAdminStatus.ready:
              return const _MessagesList();
          }
        },
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<MessagesAdminCubit, MessagesAdminState>(
                      builder: (context, state) => Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.loc.messagesAdminCount(
                              state.messages.length,
                            ),
                            style: theme.textTheme.headlineMedium,
                          ),
                          if (state.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                context.loc.messagesAdminUnreadCount(
                                  state.unreadCount,
                                ),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<MessagesAdminCubit, MessagesAdminState>(
                    buildWhen: (previous, current) =>
                        previous.unreadCount != current.unreadCount,
                    builder: (context, state) {
                      final cubit = context.read<MessagesAdminCubit>();
                      return IconButton(
                        tooltip: context.loc.messagesAdminMarkAllRead,
                        onPressed: state.unreadCount == 0
                            ? null
                            : cubit.markAllAsRead,
                        icon: const Icon(Icons.done_all_rounded),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: BlocBuilder<MessagesAdminCubit, MessagesAdminState>(
                    builder: (context, state) {
                      if (state.messages.isEmpty) {
                        return Center(
                          child: Text(
                            context.loc.messagesAdminEmpty,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final bool busy = state.busyIds.contains(message.id);
                          return _MessageRow(
                            key: ValueKey(message.id),
                            message: message,
                            busy: busy,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({super.key, required this.message, required this.busy});

  final ContactMessage message;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: !busy,
      onTap: () =>
          context.read<MessagesAdminCubit>().open(message).then((fresh) {
            if (fresh != null && context.mounted) _showDetails(context, fresh);
          }),
      leading: CircleAvatar(
        backgroundColor: message.isUnread
            ? scheme.primary.withValues(alpha: 0.15)
            : scheme.surfaceContainerHighest,
        foregroundColor: message.isUnread
            ? scheme.primary
            : scheme.onSurfaceVariant,
        child: Text(
          message.name.isNotEmpty ? message.name[0].toUpperCase() : '?',
          style: theme.textTheme.titleMedium,
        ),
      ),
      title: Row(
        children: [
          if (message.isUnread)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: Icon(Icons.circle, size: 8, color: scheme.primary),
            ),
          Expanded(
            child: Text(
              message.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: message.isUnread ? FontWeight.w700 : null,
              ),
            ),
          ),
          Text(_relativeDate(context), style: theme.textTheme.labelMedium),
        ],
      ),
      subtitle: Text(
        '${message.email}\n${_snippet(message.message)}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: IconButton(
        tooltip: context.loc.commonDelete,
        onPressed: busy
            ? null
            : () => context.read<MessagesAdminCubit>().delete(message.id),
        icon: Icon(
          Icons.delete_outline_rounded,
          color: scheme.error.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  String _snippet(String text) {
    final String flat = text.replaceAll('\n', ' ').trim();
    return flat.length <= 90 ? flat : '${flat.substring(0, 90)}…';
  }

  String _relativeDate(BuildContext context) {
    final loc = context.loc;
    final Duration diff = DateTime.now().difference(message.createdAt);
    if (diff.inDays == 0) return loc.updatedToday;
    if (diff.inDays == 1) return loc.updatedYesterday;
    if (diff.inDays < 30) return loc.updatedDaysAgo(diff.inDays);
    return loc.updatedDaysAgo(diff.inDays ~/ 30 * 30);
  }

  void _showDetails(BuildContext context, ContactMessage fresh) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);
        final loc = dialogContext.loc;
        return AlertDialog(
          title: Text(fresh.name),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  fresh.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                if ((fresh.phone ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SelectableText(
                    fresh.phone!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _relativeDate(dialogContext),
                  style: theme.textTheme.labelMedium,
                ),
                const Divider(height: 24),
                SelectableText(fresh.message, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => composeEmail(
                to: fresh.email,
                subject: 'Re: your portfolio message',
                body: '',
              ),
              icon: const Icon(Icons.reply_rounded, size: 18),
              label: Text(loc.messagesAdminReply),
            ),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<MessagesAdminCubit>().delete(fresh.id);
              },
              child: Text(loc.commonDelete),
            ),
          ],
        );
      },
    );
  }
}
