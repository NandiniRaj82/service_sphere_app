// ─────────────────────────────────────────────────────────────────────────────
// Forgot Password Screen — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).sendPasswordReset(_emailCtrl.text);
    if (mounted && ok) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _sent ? _SuccessView() : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                  ).animate().fadeIn(),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryLight, size: 40),
                  ).animate(delay: 100.ms).fadeIn().scale(),

                  const SizedBox(height: 24),

                  Text(AppStrings.resetPass, style: AppTextStyles.displaySmall)
                      .animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email address and we\'ll send you a link to reset your password.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 36),

                  AppTextField(
                    label: AppStrings.email,
                    hint: 'Enter your registered email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 28),

                  GradientButton(
                    label: AppStrings.sendReset,
                    onPressed: _send,
                    isLoading: authState.isLoading,
                    width: double.infinity,
                    icon: Icons.send_rounded,
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_rounded, color: AppColors.success, size: 56),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 28),
          Text('Email Sent!', style: AppTextStyles.displaySmall).animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 12),
          Text(
            'Check your inbox for password reset instructions. (Mock — no real email sent)',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 32),
          GradientButton(
            label: 'Back to Login',
            onPressed: () => context.go('/login'),
            icon: Icons.login_rounded,
          ).animate(delay: 500.ms).fadeIn(),
        ],
      ),
    );
  }
}
