// ─────────────────────────────────────────────────────────────────────────────
// Admin Manage Services Screen
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/app_providers.dart';

class AdminManageServicesScreen extends ConsumerWidget {
  const AdminManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allServices = ref.watch(servicesProvider).all;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allServices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final s = allServices[i];
          return GlassCard(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: s.isActive ? AppColors.primaryGradient : const LinearGradient(colors: [Color(0xFF374151), Color(0xFF4B5563)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.home_repair_service, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.title, style: AppTextStyles.h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(s.providerName, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Row(children: [
                  Text(s.category, style: AppTextStyles.bodySmall),
                  const SizedBox(width: 10),
                  Text(AppFormatters.currency(s.price), style: AppTextStyles.priceSmall),
                  const Spacer(),
                  Icon(Icons.star_rounded, size: 13, color: AppColors.warning),
                  Text(' ${s.rating.toStringAsFixed(1)}', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  // Toggle active
                  GestureDetector(
                    onTap: () => ref.read(servicesProvider.notifier).updateService(s.copyWith(isActive: !s.isActive)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: s.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: s.isActive ? AppColors.success : AppColors.error, width: 0.5),
                      ),
                      child: Text(s.isActive ? '● Active' : '● Inactive',
                        style: AppTextStyles.caption.copyWith(color: s.isActive ? AppColors.success : AppColors.error)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Toggle featured
                  GestureDetector(
                    onTap: () => ref.read(servicesProvider.notifier).updateService(s.copyWith(isFeatured: !s.isFeatured)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: s.isFeatured ? AppColors.warning.withOpacity(0.1) : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: s.isFeatured ? AppColors.warning : AppColors.borderDark, width: 0.5),
                      ),
                      child: Text(s.isFeatured ? '★ Featured' : '☆ Feature',
                        style: AppTextStyles.caption.copyWith(color: s.isFeatured ? AppColors.warning : AppColors.textMuted)),
                    ),
                  ),
                ]),
              ])),
            ]),
          );
        },
      ),
    );
  }
}
