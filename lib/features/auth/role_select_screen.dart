// ─────────────────────────────────────────────────────────────────────────────
// Role Select Screen — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/widgets/app_widgets.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo + Title
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.home_repair_service_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    ShaderMask(
                      shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                      child: Text('Service Sphere', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 48),
                Text(AppStrings.selectRole, style: AppTextStyles.displaySmall)
                    .animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(AppStrings.selectRoleSub, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                    .animate(delay: 150.ms).fadeIn(),
                const SizedBox(height: 40),

                // Role Cards
                _RoleCard(
                  delay: 200,
                  icon: Icons.person_rounded,
                  title: 'Customer',
                  subtitle: 'Browse and book services from top-rated providers near you.',
                  gradient: AppColors.primaryGradient,
                  role: 'user',
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  delay: 300,
                  icon: Icons.home_repair_service_rounded,
                  title: 'Service Provider',
                  subtitle: 'Manage your services, accept bookings, and grow your business.',
                  gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF10B981)]),
                  role: 'provider',
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  delay: 400,
                  icon: Icons.admin_panel_settings_rounded,
                  title: 'Administrator',
                  subtitle: 'Manage the platform, users, providers, and view analytics.',
                  gradient: const LinearGradient(colors: [Color(0xFFBE185D), Color(0xFFEC4899)]),
                  role: 'admin',
                ),

                const Spacer(),
                Center(
                  child: Text(
                    'Demo credentials available on login screen',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final int delay;
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final String role;

  const _RoleCard({
    required this.delay, required this.icon, required this.title,
    required this.subtitle, required this.gradient, required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('${AppRoutes.login}?role=$role'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
