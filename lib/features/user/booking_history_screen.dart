// ─────────────────────────────────────────────────────────────────────────────
// Booking History Screen — User Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/app_providers.dart';

class BookingHistoryScreen extends ConsumerWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(userBookingsProvider);
    final active    = bookings.where((b) => b.status.isActive).toList();
    final past      = bookings.where((b) => !b.status.isActive).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(
              bookings: active,
              emptyTitle: 'No active bookings',
              emptySubtitle: 'Book a service to get started',
            ),
            _BookingList(
              bookings: past.where((b) => b.status == BookingStatus.completed).toList(),
              emptyTitle: 'No completed bookings yet',
            ),
            _BookingList(bookings: bookings, emptyTitle: 'No bookings yet'),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  final List<BookingModel> bookings;
  final String emptyTitle;
  final String? emptySubtitle;

  const _BookingList({required this.bookings, required this.emptyTitle, this.emptySubtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_rounded,
        title: emptyTitle,
        subtitle: emptySubtitle,
        action: emptySubtitle != null
            ? GradientButton(label: 'Browse Services', onPressed: () => context.go('/user/services'))
            : null,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final b = bookings[i];
        return BookingCard(
          booking: b,
          onTap: () => context.push(AppRoutes.trackBooking.replaceAll(':id', b.id)),
          onTrack: b.status.isActive ? () => context.push(AppRoutes.trackBooking.replaceAll(':id', b.id)) : null,
          onCancel: b.status == BookingStatus.pending
              ? () => _confirmCancel(context, ref, b.id)
              : null,
        );
      },
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, String bookingId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            onPressed: () {
              ref.read(bookingsProvider.notifier).cancelBooking(bookingId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled'), backgroundColor: AppColors.error),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}
