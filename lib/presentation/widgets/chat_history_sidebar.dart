import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/conversation_provider.dart';

class ChatHistorySidebar extends ConsumerWidget {
  final String? currentConversationId;
  final VoidCallback onClose;

  const ChatHistorySidebar({
    super.key,
    required this.currentConversationId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(Icons.history, color: theme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Riwayat Curhat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: 'Tutup Sidebar',
                ),
              ],
            ),
          ),

          // New Chat Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final newId = await ref
                    .read(conversationProvider.notifier)
                    .createNewConversation();
                if (context.mounted) {
                  context.go('/chat/$newId');
                  onClose();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Curhat Baru'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Conversation List
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.conversations.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada riwayat curhat.',
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.conversations.length,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          final conversation = state.conversations[index];
                          final isSelected =
                              conversation.id == currentConversationId;

                          return Dismissible(
                            key: Key(conversation.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus chat ini?'),
                                  content: const Text(
                                      'Obrolan ini akan hilang selamanya.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (_) {
                              ref
                                  .read(conversationProvider.notifier)
                                  .deleteConversation(conversation.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.primaryColor.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () {
                                  context.go('/chat/${conversation.id}');
                                  onClose();
                                },
                                title: Text(
                                  conversation.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('dd MMM, HH:mm')
                                      .format(conversation.lastMessageTimestamp),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: _getVibeColor(
                                      conversation.moodVibe, theme),
                                  radius: 6,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Color _getVibeColor(String vibe, ThemeData theme) {
    switch (vibe.toLowerCase()) {
      case 'empathetic':
        return Colors.purple;
      case 'logical':
        return Colors.blue;
      case 'listener':
        return Colors.cyan;
      case 'comedic':
        return Colors.orange;
      default:
        return theme.disabledColor;
    }
  }
}
