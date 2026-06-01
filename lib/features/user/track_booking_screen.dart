// ─────────────────────────────────────────────────────────────────────────────
// Track Booking Screen — Real-time Status Tracker
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
import '../../providers/app_providers.dart';

class TrackBookingScreen extends ConsumerWidget {
  final String bookingId;
  const TrackBookingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBookings = ref.watch(bookingsProvider);
    final booking = allBookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => allBookings.first,
    );

    final steps = _buildSteps(booking.status);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Track Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Booking ID header
            GlassCard(
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _statusColor(booking.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.receipt_long_rounded, color: _statusColor(booking.status), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(booking.serviceTitle, style: AppTextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('ID: ${booking.id.substring(0, min(booking.id.length, 14))}', style: AppTextStyles.caption),
                ])),
                _StatusBadge(status: booking.status),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 16),

            // Schedule info
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Appointment', style: AppTextStyles.h4),
                const SizedBox(height: 12),
                Row(children: [
                  _Detail(Icons.calendar_today, AppFormatters.date(booking.scheduledAt)),
                  const SizedBox(width: 20),
                  _Detail(Icons.access_time, AppFormatters.time(booking.scheduledAt)),
                  const SizedBox(width: 20),
                  _Detail(Icons.timer_outlined, booking.durationMinutes ~/ 60 > 0 ? '${booking.durationMinutes ~/ 60}h' : '${booking.durationMinutes}m'),
                ]),
                if (booking.address != null) ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Expanded(child: Text(booking.address!, style: AppTextStyles.bodySmall)),
                  ]),
                ],
              ]),
            ).animate(delay: 80.ms).fadeIn(),
            const SizedBox(height: 20),

            // Progress stepper
            Text('Booking Progress', style: AppTextStyles.h3).animate(delay: 120.ms).fadeIn(),
            const SizedBox(height: 16),
            ...List.generate(steps.length, (i) {
              final step = steps[i];
              final isLast = i == steps.length - 1;
              return _StepItem(
                icon: step['icon'] as IconData,
                title: step['title'] as String,
                subtitle: step['subtitle'] as String,
                state: step['state'] as _StepState,
                isLast: isLast,
                delay: 150 + i * 100,
              );
            }),

            const SizedBox(height: 20),

            // Provider info
            GlassCard(
              child: Row(children: [
                AvatarWidget(name: booking.providerName, radius: 24),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(booking.providerName, style: AppTextStyles.h4),
                  Text('Service Provider', style: AppTextStyles.bodySmall),
                ])),
                IconButton(
                  onPressed: () => context.push(
                    AppRoutes.userChat.replaceAll(':roomId', '${booking.userId}_${booking.providerId}'),
                    extra: {'providerName': booking.providerName, 'userId': booking.userId},
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryLight),
                  ),
                ),
              ]),
            ).animate(delay: 400.ms).fadeIn(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:   return AppColors.statusPending;
      case BookingStatus.confirmed: return AppColors.statusConfirmed;
      case BookingStatus.rejected:  return AppColors.statusRejected;
      case BookingStatus.completed: return AppColors.statusCompleted;
      case BookingStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  List<Map<String, dynamic>> _buildSteps(BookingStatus status) {
    _StepState s(BookingStatus threshold) {
      final order = [BookingStatus.pending, BookingStatus.confirmed, BookingStatus.completed];
      final statusIdx = order.indexOf(status);
      final threshIdx = order.indexOf(threshold);
      if (status == BookingStatus.cancelled || status == BookingStatus.rejected) {
        return threshold == BookingStatus.pending ? _StepState.done : _StepState.cancelled;
      }
      if (statusIdx > threshIdx) return _StepState.done;
      if (statusIdx == threshIdx) return _StepState.active;
      return _StepState.upcoming;
    }

    return [
      {'icon': Icons.check_circle_outline,  'title': 'Booking Placed',    'subtitle': 'Your request has been received', 'state': s(BookingStatus.pending)},
      {'icon': Icons.verified_rounded,       'title': 'Provider Confirmed','subtitle': 'Provider accepted your booking',  'state': s(BookingStatus.confirmed)},
      {'icon': Icons.directions_run_rounded, 'title': 'Provider En Route', 'subtitle': 'Technician is heading your way',  'state': status == BookingStatus.confirmed ? _StepState.active : s(BookingStatus.confirmed)},
      {'icon': Icons.handshake_rounded,      'title': 'Service Ongoing',   'subtitle': 'Work is in progress',             'state': s(BookingStatus.completed)},
      {'icon': Icons.star_rounded,           'title': 'Completed',         'subtitle': 'Service delivered successfully',  'state': s(BookingStatus.completed)},
    ];
  }
}

enum _StepState { done, active, upcoming, cancelled }

class _StepItem extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  final _StepState state; final bool isLast; final int delay;

  const _StepItem({required this.icon, required this.title, required this.subtitle,
    required this.state, required this.isLast, required this.delay});

  @override
  Widget build(BuildContext context) {
    final Color col;
    switch (state) {
      case _StepState.done:      col = AppColors.success;       break;
      case _StepState.active:    col = AppColors.primary;       break;
      case _StepState.upcoming:  col = AppColors.textMuted;     break;
      case _StepState.cancelled: col = AppColors.statusCancelled; break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: col.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: col.withOpacity(0.5), width: 2),
            ),
            child: Icon(icon, color: col, size: 18),
          ),
          if (!isLast) Container(width: 2, height: 40, color: col.withOpacity(0.3)),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyles.labelLarge.copyWith(color: state == _StepState.upcoming ? AppColors.textMuted : AppColors.textPrimary)),
              Text(subtitle, style: AppTextStyles.caption),
              SizedBox(height: isLast ? 0 : 24),
            ]),
          ),
        ),
        if (state == _StepState.done)
          Padding(padding: const EdgeInsets.only(top: 10), child: Icon(Icons.check_rounded, color: AppColors.success, size: 16)),
      ],
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0);
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

class _Detail extends StatelessWidget {
  final IconData icon; final String text;
  const _Detail(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 14, color: AppColors.textMuted),
    const SizedBox(width: 4),
    Text(text, style: AppTextStyles.bodySmall),
  ]);
}
