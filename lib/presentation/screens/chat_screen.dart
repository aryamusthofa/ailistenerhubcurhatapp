import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat/modern_message_bubble.dart';
import '../widgets/chat/typing_indicator.dart';
import '../widgets/fx/glass_container.dart';
import '../widgets/themeable_container.dart';
import '../widgets/chat_history_sidebar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    ref.read(chatProvider.notifier).sendMessage(text, widget.conversationId);

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final chatHistory = ref.watch(chatHistoryProvider(widget.conversationId));
    final chatState = ref.watch(chatProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: ChatHistorySidebar(
        currentConversationId: widget.conversationId,
        onClose: () => Navigator.pop(context),
      ),
      body: ThemeableContainer(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header with Glass Effect
              GlassContainer(
                margin: const EdgeInsets.all(12),
                height: 60,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Navigation & Sidebar
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.go('/home'),
                            tooltip: 'Kembali ke Beranda',
                            color: theme.colorScheme.primary,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            tooltip: 'Riwayat Percakapan',
                          ),
                        ],
                      ),
                      // Title
                      Text(
                        'AI Listener',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      // Empathy + Settings
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_satisfied_alt,
                              color: theme.colorScheme.secondary,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    '🤗 Terima kasih sudah berbagi perasaanmu!',
                                  ),
                                  backgroundColor:
                                      theme.colorScheme.secondary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              ref
                                  .read(chatProvider.notifier)
                                  .sendMessage('[ACTION: EMPATHY_REACT]', widget.conversationId);
                            },
                            tooltip: 'Reaksi Empati',
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () => context.push('/settings'),
                            tooltip: 'Pengaturan',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Chat History + Messages Layout
              Expanded(
                child: Row(
                  children: [
                    // Messages Area
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: chatHistory.when(
                              data: (messages) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                                return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = messages[index];
                                    return ModernMessageBubble(
                                      message: msg.content,
                                      isAI: !msg.isUser,
                                      timestamp: msg.timestamp,
                                      modelName: msg.modelUsed,
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, stack) => Center(
                                child: Text('Error: $error'),
                              ),
                            ),
                          ),
                          // AI Typing Indicator
                          if (chatState.isLoading)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TypingIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Premium Input Field
              Padding(
                padding: const EdgeInsets.all(12),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.05),
                    ),
                    child: Row(
                      children: [
                        // Input TextField
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Cerita apa yang ingin kau bagikan...',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 15,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                            maxLines: null,
                          ),
                        ),
                        // Send Button
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _sendMessage,
                                customBorder: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
