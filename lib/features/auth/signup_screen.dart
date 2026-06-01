// ─────────────────────────────────────────────────────────────────────────────
// Signup Screen — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final String role;
  const SignupScreen({super.key, this.role = 'user'});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _emailCtrl  = TextEditingController();
  final _phoneCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    final role = UserRole.values.firstWhere(
      (r) => r.name == widget.role, orElse: () => UserRole.user,
    );
    final ok = await ref.read(authProvider.notifier).signup(
      name: _nameCtrl.text, email: _emailCtrl.text,
      password: _passCtrl.text, phone: _phoneCtrl.text, role: role,
    );
    if (!mounted) return;
    if (ok) {
      switch (role) {
        case UserRole.admin:    context.go(AppRoutes.adminDashboard);    break;
        case UserRole.provider: context.go(AppRoutes.providerDashboard); break;
        default:                context.go(AppRoutes.userHome);
      }
    } else {
      final err = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err ?? 'Signup failed'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go('${AppRoutes.login}?role=${widget.role}'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                  ).animate().fadeIn(),

                  const SizedBox(height: 24),

                  Text('Create Account', style: AppTextStyles.displaySmall)
                      .animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 6),
                  Text('Join Service Sphere as a ${widget.role}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                      .animate(delay: 150.ms).fadeIn(),

                  const SizedBox(height: 32),

                  AppTextField(
                    label: AppStrings.fullName,
                    hint: 'Enter your full name',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) => Validators.minLength(v, 2, fieldName: 'Name'),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.email,
                    hint: 'Enter your email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ).animate(delay: 240.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.phone,
                    hint: '+91 XXXXX XXXXX',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: Validators.phone,
                  ).animate(delay: 280.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.password,
                    hint: 'Min 6 characters',
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.password,
                    suffix: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ).animate(delay: 320.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.confirmPass,
                    hint: 'Re-enter your password',
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (v) => Validators.confirmPassword(v, _passCtrl.text),
                    suffix: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ).animate(delay: 360.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 28),

                  GradientButton(
                    label: 'Create Account',
                    onPressed: _signup,
                    isLoading: authState.isLoading,
                    width: double.infinity,
                    icon: Icons.person_add_rounded,
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.hasAccount, style: AppTextStyles.bodySmall),
                        TextButton(
                          onPressed: () => context.go('${AppRoutes.login}?role=${widget.role}'),
                          child: Text(AppStrings.login, style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  ).animate(delay: 450.ms).fadeIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
