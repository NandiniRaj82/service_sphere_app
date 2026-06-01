// ─────────────────────────────────────────────────────────────────────────────
// Chat Screen — User ↔ Provider real-time messaging
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> extra;

  const ChatScreen({super.key, required this.chatRoomId, required this.extra});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _msgCtrl   = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(currentUserProvider);
    ref.read(chatProvider(widget.chatRoomId).notifier).sendMessage(
      user?.id ?? 'u1', user?.name ?? 'User', text,
    );
    _msgCtrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: 300.ms, curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages  = ref.watch(chatProvider(widget.chatRoomId));
    final user      = ref.watch(currentUserProvider);
    final otherName = widget.extra['providerName'] as String? ??
                      widget.extra['userName'] as String? ?? 'Provider';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Row(children: [
          AvatarWidget(name: otherName, radius: 18, backgroundColor: AppColors.primaryLight),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(otherName, style: AppTextStyles.h4),
            Text('Online', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg    = messages[i];
                final isMe   = msg.senderId == user?.id;
                final showTime = i == 0 || messages[i - 1].createdAt.difference(msg.createdAt).abs().inMinutes > 5;

                return Column(
                  children: [
                    if (showTime)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(AppFormatters.timeAgo(msg.createdAt), style: AppTextStyles.caption),
                      ),
                    Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isMe ? AppColors.primaryGradient : null,
                          color: isMe ? null : AppColors.cardDark,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          border: isMe ? null : Border.all(color: AppColors.borderDark),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(msg.text, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 2),
                            Text(AppFormatters.time(msg.createdAt), style: AppTextStyles.caption.copyWith(fontSize: 9)),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0),
                  ],
                );
              },
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              border: const Border(top: BorderSide(color: AppColors.borderDark)),
            ),
            child: SafeArea(
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: TextField(
                      controller: _msgCtrl,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 4, minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
