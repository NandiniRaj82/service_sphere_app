// ─────────────────────────────────────────────────────────────────────────────
// Booking Requests Screen — Provider Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class BookingRequestsScreen extends ConsumerWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final allBookings = ref.watch(bookingsProvider);
    final myBookings = allBookings.where((b) => b.providerId == (user?.id ?? 'p1')).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final pending   = myBookings.where((b) => b.status == BookingStatus.pending).toList();
    final confirmed = myBookings.where((b) => b.status == BookingStatus.confirmed).toList();
    final completed = myBookings.where((b) => b.status == BookingStatus.completed).toList();
    final rejected  = myBookings.where((b) => b.status == BookingStatus.rejected || b.status == BookingStatus.cancelled).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          title: const Text('Booking Requests'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Pending (${pending.length})'),
              Tab(text: 'Confirmed (${confirmed.length})'),
              Tab(text: 'Completed (${completed.length})'),
              Tab(text: 'Rejected (${rejected.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingListView(bookings: pending,   canAct: true, ref: ref),
            _BookingListView(bookings: confirmed,  canAct: false, ref: ref, canComplete: true),
            _BookingListView(bookings: completed,  canAct: false, ref: ref),
            _BookingListView(bookings: rejected,   canAct: false, ref: ref),
          ],
        ),
      ),
    );
  }
}

class _BookingListView extends StatelessWidget {
  final List<BookingModel> bookings;
  final bool canAct;
  final bool canComplete;
  final WidgetRef ref;

  const _BookingListView({required this.bookings, required this.canAct, required this.ref, this.canComplete = false});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyStateWidget(icon: Icons.inbox_rounded, title: 'No bookings here');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final b = bookings[i];
        return GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              AvatarWidget(name: b.userName, radius: 20, backgroundColor: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.userName, style: AppTextStyles.h4),
                Text(b.userPhone, style: AppTextStyles.caption),
              ])),
              _StatusBadge(status: b.status),
            ]),
            const SizedBox(height: 10),
            const Divider(color: AppColors.borderDark, height: 1),
            const SizedBox(height: 10),

            // Service
            Row(children: [
              const Icon(Icons.home_repair_service, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(child: Text(b.serviceTitle, style: AppTextStyles.bodySmall)),
              Text(AppFormatters.currency(b.servicePrice), style: AppTextStyles.priceSmall),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(AppFormatters.date(b.scheduledAt), style: AppTextStyles.bodySmall),
              const SizedBox(width: 10),
              const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(AppFormatters.time(b.scheduledAt), style: AppTextStyles.bodySmall),
            ]),
            if (b.notes != null && b.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.notes_rounded, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Expanded(child: Text(b.notes!, style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis)),
              ]),
            ],

            // Actions
            if (canAct) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(bookingsProvider.notifier).updateStatus(b.id, BookingStatus.rejected);
                    _snack(context, 'Booking rejected', AppColors.error);
                  },
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error.withOpacity(0.15), foregroundColor: AppColors.error, elevation: 0),
                )),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(bookingsProvider.notifier).updateStatus(b.id, BookingStatus.confirmed);
                    _snack(context, 'Booking accepted ✓', AppColors.success);
                  },
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success.withOpacity(0.15), foregroundColor: AppColors.success, elevation: 0),
                )),
              ]),
            ],
            if (canComplete) ...[
              const SizedBox(height: 12),
              GradientButton(
                label: 'Mark as Completed',
                icon: Icons.check_circle_rounded,
                width: double.infinity,
                onPressed: () {
                  ref.read(bookingsProvider.notifier).updateStatus(b.id, BookingStatus.completed);
                  _snack(context, 'Booking marked as completed!', AppColors.success);
                },
              ),
            ],
          ]),
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }

  void _snack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color c;
    switch (status) {
      case BookingStatus.pending:   c = AppColors.statusPending;   break;
      case BookingStatus.confirmed: c = AppColors.statusConfirmed; break;
      case BookingStatus.rejected:  c = AppColors.statusRejected;  break;
      case BookingStatus.completed: c = AppColors.statusCompleted; break;
      case BookingStatus.cancelled: c = AppColors.statusCancelled; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status.label, style: AppTextStyles.labelSmall.copyWith(color: c)),
    );
  }
}
