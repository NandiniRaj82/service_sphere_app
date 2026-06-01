// ─────────────────────────────────────────────────────────────────────────────
// Booking Confirmation Screen — Success Animation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../models/booking_model.dart';
import '../../../models/service_model.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/auth_provider.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> bookingData;
  const BookingConfirmationScreen({super.key, required this.bookingData});

  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends ConsumerState<BookingConfirmationScreen> {
  late final BookingModel _booking;

  @override
  void initState() {
    super.initState();
    _createBooking();
  }

  void _createBooking() {
    final service      = widget.bookingData['service'] as ServiceModel;
    final scheduledAt  = widget.bookingData['scheduledAt'] as DateTime;
    final user         = ref.read(currentUserProvider);
    final paymentId    = widget.bookingData['paymentId'] as String?;
    final method       = widget.bookingData['paymentMethod'] as String? ?? 'Cash';

    _booking = BookingModel(
      id: 'B_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'u1',
      userName: user?.name ?? 'User',
      userPhone: user?.phone ?? '',
      providerId: service.providerId,
      providerName: service.providerName,
      serviceId: service.id,
      serviceTitle: service.title,
      serviceCategory: service.category,
      servicePrice: service.price,
      scheduledAt: scheduledAt,
      durationMinutes: service.durationMinutes,
      status: BookingStatus.pending,
      notes: widget.bookingData['notes'] as String?,
      address: widget.bookingData['address'] as String?,
      paymentId: paymentId,
      isPaid: method != 'Pay on Visit',
      createdAt: DateTime.now(),
    );

    // Add to bookings state
    ref.read(bookingsProvider.notifier).addBooking(_booking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success.withOpacity(0.4), width: 3),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 60),
              )
              .animate()
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 700.ms, curve: Curves.elasticOut)
              .fadeIn(),

              const SizedBox(height: 24),

              Text('Booking Confirmed! 🎉', style: AppTextStyles.displaySmall, textAlign: TextAlign.center)
                  .animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 8),
              Text(
                'Your booking has been placed successfully. The provider will confirm shortly.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate(delay: 500.ms).fadeIn(),

              const SizedBox(height: 32),

              // Booking details card
              GlassCard(
                child: Column(children: [
                  _ConfirmRow(Icons.confirmation_number_rounded, 'Booking ID', _booking.id.substring(0, 12)),
                  _ConfirmRow(Icons.home_repair_service, 'Service', _booking.serviceTitle),
                  _ConfirmRow(Icons.person_rounded, 'Provider', _booking.providerName),
                  _ConfirmRow(Icons.calendar_today, 'Date', AppFormatters.date(_booking.scheduledAt)),
                  _ConfirmRow(Icons.access_time, 'Time', AppFormatters.time(_booking.scheduledAt)),
                  _ConfirmRow(Icons.attach_money, 'Amount', AppFormatters.currency(_booking.servicePrice)),
                  _ConfirmRow(Icons.payment, 'Payment', _booking.isPaid ? 'Paid ✓' : 'Pay on Visit'),
                ]),
              ).animate(delay: 600.ms).fadeIn(),

              const SizedBox(height: 32),

              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.trackBooking.replaceAll(':id', _booking.id)),
                    icon: const Icon(Icons.track_changes_rounded),
                    label: const Text('Track'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: 'Go Home',
                    icon: Icons.home_rounded,
                    onPressed: () => context.go(AppRoutes.userHome),
                  ),
                ),
              ]).animate(delay: 700.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _ConfirmRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 16, color: AppColors.primary),
      const SizedBox(width: 10),
      Text(label, style: AppTextStyles.bodySmall),
      const Spacer(),
      Text(value, style: AppTextStyles.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );
}
