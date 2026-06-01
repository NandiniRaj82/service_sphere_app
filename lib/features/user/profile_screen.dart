// ─────────────────────────────────────────────────────────────────────────────
// User Profile Screen
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
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/app_providers.dart' show ThemeNotifier, themeProvider;

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user       = ref.watch(currentUserProvider);
    final themeMode  = ref.watch(themeProvider);
    final isDark     = themeMode == ThemeMode.dark;
    final bookings   = ref.watch(userBookingsProvider);
    final completed  = bookings.where((b) => b.status.name == 'completed').length;
    final totalSpend = bookings.where((b) => b.isPaid).fold<double>(0, (s, b) => s + b.servicePrice);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            GlassCard(
              child: Column(children: [
                AvatarWidget(name: user?.name ?? 'U', radius: 44, backgroundColor: AppColors.primary),
                const SizedBox(height: 12),
                Text(user?.name ?? 'User', style: AppTextStyles.h1),
                Text(user?.email ?? '', style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(user?.roleLabel ?? 'User', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryLight)),
                ),
                const SizedBox(height: 16),
                // Stats
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _Stat(label: 'Bookings', value: '${bookings.length}'),
                  Container(width: 1, height: 40, color: AppColors.borderDark),
                  _Stat(label: 'Completed', value: '$completed'),
                  Container(width: 1, height: 40, color: AppColors.borderDark),
                  _Stat(label: 'Total Spend', value: AppFormatters.currency(totalSpend)),
                ]),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),

            // Settings section
            Text('Account Settings', style: AppTextStyles.h3).animate(delay: 100.ms).fadeIn(),
            const SizedBox(height: 12),

            _MenuItem(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () {}, delay: 120),
            _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () {}, delay: 140),
            _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications), delay: 160),
            _MenuItem(icon: Icons.lock_outline_rounded, label: 'Change Password', onTap: () {}, delay: 180),
            const SizedBox(height: 8),

            // Dark mode toggle
            GlassCard(
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.primaryLight, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(isDark ? 'Dark Mode' : 'Light Mode', style: AppTextStyles.labelLarge)),
                Switch(
                  value: isDark,
                  onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                ),
              ]),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 8),

            _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}, delay: 220),
            _MenuItem(icon: Icons.info_outline_rounded, label: 'About App', onTap: () {}, delay: 240),
            const SizedBox(height: 16),

            // Logout
            GlassCard(
              onTap: () => _confirmLogout(context, ref),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                ),
                const SizedBox(width: 14),
                Text('Logout', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ]),
            ).animate(delay: 260.ms).fadeIn(),
            const SizedBox(height: 32),

            Center(child: Text('Service Sphere v1.0.0', style: AppTextStyles.caption)).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.roleSelect);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label; final String value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: AppTextStyles.h2),
    Text(label, style: AppTextStyles.caption),
  ]);
}

class _MenuItem extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final int delay;
  const _MenuItem({required this.icon, required this.label, required this.onTap, required this.delay});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: GlassCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primaryLight, size: 20),
        ),
        const SizedBox(width: 14),
        Text(label, style: AppTextStyles.labelLarge),
        const Spacer(),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      ]),
    ),
  ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideX(begin: 0.05, end: 0);
}
