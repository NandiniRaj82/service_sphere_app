// ─────────────────────────────────────────────────────────────────────────────
// Booking Summary Screen
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../models/service_model.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const BookingSummaryScreen({super.key, required this.bookingData});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _notesCtrl = TextEditingController();
  final _addressCtrl = TextEditingController(text: '14 MG Road, Bangalore 560001');

  @override
  void dispose() { _notesCtrl.dispose(); _addressCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final service     = widget.bookingData['service'] as ServiceModel;
    final scheduledAt = widget.bookingData['scheduledAt'] as DateTime;
    final timeSlot    = widget.bookingData['timeSlot'] as String;
    final tax         = service.price * 0.18;
    final total       = service.price + tax;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Booking Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Service info
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Service Details', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                _Row('Service', service.title),
                _Row('Provider', service.providerName),
                _Row('Category', service.category),
                _Row('Duration', service.durationLabel),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 12),

            // Schedule info
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Schedule', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                _Row('Date', AppFormatters.date(scheduledAt)),
                _Row('Time', timeSlot),
                _Row('Day', AppFormatters.weekday(scheduledAt)),
              ]),
            ).animate(delay: 80.ms).fadeIn(),
            const SizedBox(height: 12),

            // Address
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Service Address', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Address', controller: _addressCtrl,
                  prefixIcon: Icons.location_on_outlined, maxLines: 2,
                ),
              ]),
            ).animate(delay: 120.ms).fadeIn(),
            const SizedBox(height: 12),

            // Notes
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Additional Notes', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Notes (optional)', hint: 'Describe the issue or special requirements',
                  controller: _notesCtrl, prefixIcon: Icons.notes_rounded, maxLines: 3,
                ),
              ]),
            ).animate(delay: 160.ms).fadeIn(),
            const SizedBox(height: 12),

            // Price breakdown
            GlassCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Price Breakdown', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                _Row('Service charge', AppFormatters.currency(service.price)),
                _Row('GST (18%)', AppFormatters.currency(tax)),
                const Divider(color: AppColors.borderDark, height: 20),
                Row(children: [
                  Text('Total', style: AppTextStyles.h3),
                  const Spacer(),
                  Text(AppFormatters.currency(total), style: AppTextStyles.price),
                ]),
              ]),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: const Border(top: BorderSide(color: AppColors.borderDark)),
        ),
        child: SafeArea(
          child: GradientButton(
            label: 'Proceed to Payment',
            icon: Icons.payment_rounded,
            width: double.infinity,
            onPressed: () => context.push(AppRoutes.payment, extra: {
              ...widget.bookingData,
              'notes': _notesCtrl.text,
              'address': _addressCtrl.text,
              'total': total,
              'tax': tax,
            }),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label; final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(label, style: AppTextStyles.bodySmall),
      const Spacer(),
      Text(value, style: AppTextStyles.labelMedium),
    ]),
  );
}
