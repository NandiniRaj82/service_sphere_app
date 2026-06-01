// ─────────────────────────────────────────────────────────────────────────────
// Payment Screen — Mock Razorpay/Stripe Integration UI
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

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const PaymentScreen({super.key, required this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  final _methods = [
    {'icon': Icons.credit_card_rounded,  'label': 'Credit / Debit Card',  'detail': 'Visa, Mastercard, RuPay'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'UPI',        'detail': 'PhonePe, GPay, Paytm'},
    {'icon': Icons.account_balance_rounded,        'label': 'Net Banking', 'detail': 'All major banks'},
    {'icon': Icons.money_rounded,                  'label': 'Pay on Visit', 'detail': 'Cash at the time of service'},
  ];

  Future<void> _pay() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 2000)); // mock processing
    if (!mounted) return;
    context.push(AppRoutes.bookingConfirm, extra: {
      ...widget.bookingData,
      'paymentMethod': _methods[_selectedMethod]['label'],
      'paymentId': 'PAY_${DateTime.now().millisecondsSinceEpoch}',
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.bookingData['service'] as ServiceModel;
    final total   = widget.bookingData['total'] as double;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount to pay
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                Text('Amount Payable', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(AppFormatters.currency(total), style: AppTextStyles.displayMedium),
                const SizedBox(height: 4),
                Text(service.title, style: AppTextStyles.bodySmall.copyWith(color: Colors.white60)),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 24),

            Text('Payment Method', style: AppTextStyles.h3).animate(delay: 80.ms).fadeIn(),
            const SizedBox(height: 12),

            // Payment methods
            ...List.generate(_methods.length, (i) {
              final method = _methods[i];
              final isSelected = _selectedMethod == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderDark,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(method['icon'] as IconData, color: isSelected ? AppColors.primaryLight : AppColors.textMuted, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(method['label'] as String, style: AppTextStyles.labelLarge),
                      Text(method['detail'] as String, style: AppTextStyles.bodySmall),
                    ])),
                    Icon(isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textMuted),
                  ]),
                ),
              ).animate(delay: Duration(milliseconds: 100 + i * 50)).fadeIn().slideX(begin: 0.05, end: 0);
            }),

            // Card form (only for card method)
            if (_selectedMethod == 0) ...[
              const SizedBox(height: 12),
              GlassCard(
                child: Column(children: [
                  AppTextField(label: 'Card Number', hint: '1234 5678 9012 3456',
                    prefixIcon: Icons.credit_card, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: AppTextField(label: 'Expiry', hint: 'MM/YY', keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: AppTextField(label: 'CVV', hint: '•••', obscureText: true, keyboardType: TextInputType.number)),
                  ]),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Cardholder Name', hint: 'As on card', prefixIcon: Icons.person_outline),
                ]),
              ).animate(delay: 300.ms).fadeIn(),
            ],

            // UPI form
            if (_selectedMethod == 1) ...[
              const SizedBox(height: 12),
              GlassCard(
                child: AppTextField(label: 'UPI ID', hint: 'yourname@paytm', prefixIcon: Icons.account_balance_wallet_outlined),
              ).animate(delay: 300.ms).fadeIn(),
            ],

            const SizedBox(height: 32),
            // Security notice
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.lock_rounded, size: 14, color: AppColors.success),
              const SizedBox(width: 6),
              Text('256-bit SSL Secured · Mock Integration', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
            ]).animate(delay: 350.ms).fadeIn(),
            const SizedBox(height: 80),
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
            label: _isProcessing ? 'Processing...' : 'Pay ${AppFormatters.currency(total)}',
            icon: _isProcessing ? null : Icons.lock_rounded,
            isLoading: _isProcessing,
            onPressed: _isProcessing ? null : _pay,
            width: double.infinity,
            gradient: AppColors.accentGradient,
          ),
        ),
      ),
    );
  }
}
