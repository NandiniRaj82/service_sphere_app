// ─────────────────────────────────────────────────────────────────────────────
// Admin Shell — Drawer/Sidebar Navigation
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  static final _navItems = [
    (AppRoutes.adminDashboard,  Icons.dashboard_rounded,            'Dashboard'),
    (AppRoutes.manageUsers,     Icons.people_rounded,               'Manage Users'),
    (AppRoutes.manageProviders, Icons.home_repair_service_rounded,  'Providers'),
    (AppRoutes.adminServices,   Icons.design_services_rounded,      'Services'),
    (AppRoutes.analytics,       Icons.bar_chart_rounded,            'Analytics'),
    (AppRoutes.roleManagement,  Icons.manage_accounts_rounded,      'Roles'),
    (AppRoutes.activityLogs,    Icons.history_rounded,              'Activity Logs'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user     = ref.watch(currentUserProvider);
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(_titleFor(location)),
        leading: Builder(builder: (ctx) => IconButton(
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          icon: const Icon(Icons.menu_rounded),
        )),
        actions: [
          AvatarWidget(name: user?.name ?? 'Admin', radius: 18, backgroundColor: AppColors.primary),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.surfaceDark,
          child: SafeArea(
            child: Column(
              children: [
                // Admin header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AvatarWidget(name: user?.name ?? 'Admin', radius: 30, backgroundColor: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 12),
                    Text(user?.name ?? 'Administrator', style: AppTextStyles.h3),
                    Text('Platform Administrator', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                  ]),
                ),
                const SizedBox(height: 8),

                // Nav items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: _navItems.map((item) {
                      final isSelected = location.startsWith(item.$1);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: Icon(item.$2, color: isSelected ? AppColors.primaryLight : AppColors.textMuted, size: 22),
                          title: Text(item.$3, style: AppTextStyles.labelLarge.copyWith(
                            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          )),
                          selected: isSelected,
                          selectedTileColor: AppColors.primary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onTap: () { context.go(item.$1); Navigator.pop(context); },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Logout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassCard(
                    onTap: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go(AppRoutes.roleSelect);
                    },
                    child: Row(children: [
                      const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                      const SizedBox(width: 12),
                      Text('Logout', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: child,
    );
  }

  String _titleFor(String location) {
    for (final item in _navItems) {
      if (location.startsWith(item.$1)) return item.$3;
    }
    return 'Admin';
  }
}
