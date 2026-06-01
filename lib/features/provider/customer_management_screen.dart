// ─────────────────────────────────────────────────────────────────────────────
// Customer Management Screen — Provider Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class CustomerManagementScreen extends ConsumerWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final allBookings = ref.watch(bookingsProvider);
    final myBookings  = allBookings.where((b) => b.providerId == (user?.id ?? 'p1')).toList();

    // Group by unique customers
    final customerMap = <String, List<BookingModel>>{};
    for (final b in myBookings) {
      customerMap[b.userId] = [...(customerMap[b.userId] ?? []), b];
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: Text('Customers (${customerMap.length})')),
      body: customerMap.isEmpty
          ? const EmptyStateWidget(icon: Icons.people_outline, title: 'No customers yet')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: customerMap.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final userId   = customerMap.keys.elementAt(i);
                final bookings = customerMap[userId]!;
                final latest   = bookings.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
                final totalSpend = bookings.where((b) => b.isPaid).fold<double>(0, (s, b) => s + b.servicePrice);

                return GlassCard(
                  child: Row(children: [
                    AvatarWidget(name: latest.userName, radius: 24, backgroundColor: AppColors.primary),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(latest.userName, style: AppTextStyles.h4),
                      Text(latest.userPhone, style: AppTextStyles.caption),
                      const SizedBox(height: 6),
                      Row(children: [
                        _Chip('${bookings.length} bookings', AppColors.primary),
                        const SizedBox(width: 6),
                        _Chip(AppFormatters.currency(totalSpend), AppColors.success),
                      ]),
                    ])),
                    const SizedBox(width: 8),
                    Column(children: [
                      IconButton(
                        onPressed: () => context.push(
                          AppRoutes.providerChat.replaceAll(':roomId', '${userId}_${user?.id ?? 'p1'}'),
                          extra: {'userName': latest.userName, 'providerId': user?.id ?? 'p1'},
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryLight, size: 20),
                      ),
                    ]),
                  ]),
                );
              },
            ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
  );
}
