// ─────────────────────────────────────────────────────────────────────────────
// Provider Shell — Bottom Navigation for Provider
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';

class ProviderShell extends StatelessWidget {
  final Widget child;
  const ProviderShell({super.key, required this.child});

  static final _tabs = [
    (AppRoutes.providerDashboard, Icons.dashboard_rounded,    Icons.dashboard_outlined,    'Dashboard'),
    (AppRoutes.manageServices,   Icons.home_repair_service,  Icons.home_repair_service_outlined, 'Services'),
    (AppRoutes.bookingRequests,  Icons.inbox_rounded,         Icons.inbox_outlined,         'Requests'),
    (AppRoutes.schedule,         Icons.calendar_month_rounded,Icons.calendar_month_outlined,'Schedule'),
    (AppRoutes.revenue,          Icons.bar_chart_rounded,     Icons.bar_chart_outlined,     'Revenue'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].$1)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: const Border(top: BorderSide(color: AppColors.borderDark)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSel = i == idx;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.$1),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(isSel ? tab.$2 : tab.$3, color: isSel ? AppColors.primary : AppColors.textMuted, size: 22),
                      const SizedBox(height: 3),
                      Text(tab.$4, style: AppTextStyles.caption.copyWith(
                        color: isSel ? AppColors.primary : AppColors.textMuted,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
