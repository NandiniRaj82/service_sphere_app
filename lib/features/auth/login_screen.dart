// ─────────────────────────────────────────────────────────────────────────────
// Login Screen — Service Sphere
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
import '../../services/mock_data_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String role;
  const LoginScreen({super.key, this.role = 'user'});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).login(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      final role = ref.read(authProvider).user?.role;
      switch (role) {
        case UserRole.admin:    context.go(AppRoutes.adminDashboard);    break;
        case UserRole.provider: context.go(AppRoutes.providerDashboard); break;
        default:                context.go(AppRoutes.userHome);
      }
    } else {
      final err = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err ?? 'Login failed'), backgroundColor: AppColors.error),
      );
    }
  }

  void _fillDemo(String email, String password) {
    _emailCtrl.text = email;
    _passCtrl.text  = password;
    setState(() {});
  }

  String get _roleTitle {
    switch (widget.role) {
      case 'provider': return 'Provider Login';
      case 'admin':    return 'Admin Login';
      default:         return 'Welcome Back 👋';
    }
  }

  List<Map<String, dynamic>> get _demoCreds {
    return MockDataService.demoAccounts.where((a) => a['role'] == widget.role).toList();
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
                  // Back button
                  IconButton(
                    onPressed: () => context.go(AppRoutes.roleSelect),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                  ).animate().fadeIn(),

                  const SizedBox(height: 24),

                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      widget.role.toUpperCase(),
                      style: AppTextStyles.overline.copyWith(color: AppColors.primaryLight),
                    ),
                  ).animate(delay: 50.ms).fadeIn(),

                  const SizedBox(height: 12),
                  Text(_roleTitle, style: AppTextStyles.displaySmall)
                      .animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 6),
                  Text('Sign in to your Service Sphere account', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                      .animate(delay: 150.ms).fadeIn(),

                  const SizedBox(height: 36),

                  // Form fields
                  AppTextField(
                    label: AppStrings.email,
                    hint: 'Enter your email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 16),

                  AppTextField(
                    label: AppStrings.password,
                    hint: 'Enter your password',
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.password,
                    suffix: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPass),
                      child: Text(AppStrings.forgotPass, style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
                    ),
                  ).animate(delay: 280.ms).fadeIn(),

                  const SizedBox(height: 24),

                  // Login button
                  GradientButton(
                    label: AppStrings.login,
                    onPressed: _login,
                    isLoading: authState.isLoading,
                    width: double.infinity,
                    icon: Icons.login_rounded,
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Signup link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.noAccount, style: AppTextStyles.bodySmall),
                        TextButton(
                          onPressed: () => context.go('${AppRoutes.signup}?role=${widget.role}'),
                          child: Text(AppStrings.signup, style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  ).animate(delay: 350.ms).fadeIn(),

                  const SizedBox(height: 32),

                  // Demo credentials
                  if (_demoCreds.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.borderDark)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Demo Credentials', style: AppTextStyles.caption),
                        ),
                        Expanded(child: Divider(color: AppColors.borderDark)),
                      ],
                    ).animate(delay: 400.ms).fadeIn(),
                    const SizedBox(height: 12),
                    ..._demoCreds.map((cred) => _DemoCredChip(
                      name: cred['name'] as String,
                      email: cred['email'] as String,
                      password: cred['password'] as String,
                      onTap: () => _fillDemo(cred['email'] as String, cred['password'] as String),
                    ).animate(delay: 450.ms).fadeIn()),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoCredChip extends StatelessWidget {
  final String name;
  final String email;
  final String password;
  final VoidCallback onTap;

  const _DemoCredChip({required this.name, required this.email, required this.password, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelMedium),
                  Text('$email  •  $password', style: AppTextStyles.caption),
                ],
              ),
            ),
            Text('Use', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}
