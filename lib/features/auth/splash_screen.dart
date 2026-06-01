// ─────────────────────────────────────────────────────────────────────────────
// Splash Screen — Service Sphere
// Reactively listens to AuthStatus — navigates as soon as state resolves
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;
  // Minimum splash display time (branding)
  bool _minDelayPassed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _minDelayPassed = true);
    });
  }

  void _tryNavigate(AuthStatus status, UserRole? role) {
    if (_hasNavigated || !_minDelayPassed) return;
    if (status == AuthStatus.initial || status == AuthStatus.loading) return;

    _hasNavigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (status == AuthStatus.authenticated && role != null) {
        switch (role) {
          case UserRole.admin:    context.go(AppRoutes.adminDashboard);    break;
          case UserRole.provider: context.go(AppRoutes.providerDashboard); break;
          default:                context.go(AppRoutes.userHome);
        }
      } else {
        context.go(AppRoutes.roleSelect);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state — this rebuilds whenever auth resolves
    final authState = ref.watch(authProvider);

    // Trigger navigation on every build once conditions are met
    _tryNavigate(authState.status, authState.user?.role);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 30, spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.home_repair_service_rounded, color: Colors.white, size: 52),
              )
              .animate()
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 700.ms, curve: Curves.elasticOut)
              .fadeIn(),

              const SizedBox(height: 24),

              // App name
              ShaderMask(
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: Text('Service Sphere', style: AppTextStyles.displayMedium.copyWith(color: Colors.white)),
              )
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),
              Text(
                'Expert services, at your doorstep',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              )
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms),

              const SizedBox(height: 60),

              // Loading indicator
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.borderDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
              .animate(delay: 800.ms)
              .fadeIn(duration: 400.ms),

              const SizedBox(height: 24),
              Text(
                authState.status == AuthStatus.loading ? 'Restoring session...' : 'Loading...',
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ).animate(delay: 900.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
