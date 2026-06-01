// ─────────────────────────────────────────────────────────────────────────────
// User Shell — Bottom Navigation layout
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../providers/app_providers.dart';

class UserShell extends ConsumerWidget {
  final Widget child;
  const UserShell({super.key, required this.child});

  static final _tabs = [
    (AppRoutes.userHome,      Icons.home_rounded,           Icons.home_outlined,        'Home'),
    (AppRoutes.services,      Icons.home_repair_service,    Icons.home_repair_service_outlined, 'Services'),
    (AppRoutes.bookingHistory,Icons.calendar_today_rounded, Icons.calendar_today_outlined, 'Bookings'),
    (AppRoutes.userProfile,   Icons.person_rounded,         Icons.person_outline_rounded, 'Profile'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].$1)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = _currentIndex(context);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: const Border(top: BorderSide(color: AppColors.borderDark, width: 1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab   = _tabs[i];
                final isSelected = i == idx;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.$1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isSelected ? tab.$2 : tab.$3,
                              color: isSelected ? AppColors.primary : AppColors.textMuted,
                              size: 24,
                            ),
                            // Notification badge on profile
                            if (i == 0 && unread > 0)
                              Positioned(
                                top: -4, right: -6,
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                  child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.$4,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textMuted,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
