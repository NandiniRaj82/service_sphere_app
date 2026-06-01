// ─────────────────────────────────────────────────────────────────────────────
// Provider Dashboard
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';

class ProviderDashboard extends ConsumerWidget {
  const ProviderDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final analytics = MockDataService.getProviderAnalytics(user?.id ?? 'p1');
    final allBookings = ref.watch(bookingsProvider);
    final myBookings  = allBookings.where((b) => b.providerId == (user?.id ?? 'p1')).toList();
    final pending     = myBookings.where((b) => b.status == BookingStatus.pending).toList();
    final upcoming    = myBookings.where((b) => b.status == BookingStatus.confirmed &&
        b.scheduledAt.isAfter(DateTime.now())).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF065F46), Color(0xFF1A1A2E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('Provider Dashboard', style: AppTextStyles.displaySmall),
                      Text('Welcome back, ${user?.name.split(' ').first ?? 'Provider'}!', style: AppTextStyles.bodySmall),
                    ]),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.go(AppRoutes.customers),
                icon: const Icon(Icons.people_outline_rounded),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              // Stats grid
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.3,
                children: [
                  StatCard(label: 'Total Bookings',     value: '${analytics['totalBookings']}',     icon: Icons.calendar_today_rounded,  color: AppColors.primary),
                  StatCard(label: 'Completed',          value: '${analytics['completedBookings']}', icon: Icons.check_circle_rounded,     color: AppColors.success),
                  StatCard(label: 'Pending Requests',   value: '${analytics['pendingBookings']}',   icon: Icons.pending_actions_rounded,  color: AppColors.warning),
                  StatCard(label: 'Total Revenue',      value: AppFormatters.currency((analytics['revenue'] as double)), icon: Icons.currency_rupee_rounded, color: AppColors.accent),
                ],
              ),
              const SizedBox(height: 20),

              // Pending requests
              if (pending.isNotEmpty) ...[
                SectionHeader(
                  title: '🔔 Pending Requests (${pending.length})',
                  actionLabel: 'View All',
                  onAction: () => context.go(AppRoutes.bookingRequests),
                ),
                const SizedBox(height: 12),
                ...pending.take(2).map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RequestCard(booking: b, ref: ref),
                )),
                const SizedBox(height: 16),
              ],

              // Upcoming bookings
              SectionHeader(
                title: 'Upcoming Bookings',
                actionLabel: 'Schedule',
                onAction: () => context.go(AppRoutes.schedule),
              ),
              const SizedBox(height: 12),
              if (upcoming.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: EmptyStateWidget(icon: Icons.event_available_rounded, title: 'No upcoming bookings'),
                )
              else
                ...upcoming.take(3).map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BookingCard(booking: b),
                )),

              const SizedBox(height: 80),
            ])),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BookingModel booking;
  final WidgetRef ref;
  const _RequestCard({required this.booking, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          AvatarWidget(name: booking.userName, radius: 20),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(booking.userName, style: AppTextStyles.h4),
            Text(booking.serviceTitle, style: AppTextStyles.bodySmall),
          ])),
          Text(AppFormatters.currency(booking.servicePrice), style: AppTextStyles.priceSmall),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Icon(Icons.calendar_today, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(AppFormatters.date(booking.scheduledAt), style: AppTextStyles.caption),
          const SizedBox(width: 10),
          Icon(Icons.access_time, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(AppFormatters.time(booking.scheduledAt), style: AppTextStyles.caption),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(bookingsProvider.notifier).updateStatus(booking.id, BookingStatus.rejected);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking rejected'), backgroundColor: AppColors.error));
              },
              icon: const Icon(Icons.close_rounded, size: 16),
              label: const Text('Reject'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error.withOpacity(0.2), foregroundColor: AppColors.error, elevation: 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(bookingsProvider.notifier).updateStatus(booking.id, BookingStatus.confirmed);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking confirmed ✓'), backgroundColor: AppColors.success));
              },
              icon: const Icon(Icons.check_rounded, size: 16),
              label: const Text('Accept'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success.withOpacity(0.2), foregroundColor: AppColors.success, elevation: 0),
            ),
          ),
        ]),
      ]),
    ).animate().fadeIn(duration: 300.ms);
  }
}
