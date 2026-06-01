// ─────────────────────────────────────────────────────────────────────────────
// Notifications Screen
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/notification_model.dart';
import '../../providers/app_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifier      = ref.read(notificationsProvider.notifier);
    final unread        = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Notifications${unread > 0 ? ' ($unread)' : ''}'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: notifier.markAllRead,
              child: Text('Mark all read', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No notifications',
              subtitle: 'You are all caught up!',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final n = notifications[i];
                return _NotificationCard(notification: n, onTap: () => notifier.markRead(n.id));
              },
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.bookingUpdate: return Icons.calendar_today_rounded;
      case NotificationType.payment:       return Icons.payment_rounded;
      case NotificationType.chat:          return Icons.chat_bubble_rounded;
      case NotificationType.promotion:     return Icons.local_offer_rounded;
      default:                             return Icons.info_rounded;
    }
  }

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.bookingUpdate: return AppColors.primary;
      case NotificationType.payment:       return AppColors.success;
      case NotificationType.chat:          return AppColors.info;
      case NotificationType.promotion:     return AppColors.accent;
      default:                             return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final color    = _colorFor(notification.type);

    return GlassCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(_iconFor(notification.type), color: color, size: 20),
            ),
            if (isUnread)
              Positioned(
                top: 0, right: 0,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
              ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(notification.title, style: AppTextStyles.labelLarge.copyWith(fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500)),
              const SizedBox(height: 4),
              Text(notification.body, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(AppFormatters.timeAgo(notification.createdAt), style: AppTextStyles.caption),
            ]),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
