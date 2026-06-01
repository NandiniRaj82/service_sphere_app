// ─────────────────────────────────────────────────────────────────────────────
// Manage Services Screen — Provider Feature
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
import '../../models/service_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class ManageServicesScreen extends ConsumerWidget {
  const ManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user       = ref.watch(currentUserProvider);
    final allServices = ref.watch(servicesProvider).all;
    final myServices  = allServices.where((s) => s.providerId == (user?.id ?? 'p1')).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('My Services'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.addService),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: myServices.isEmpty
          ? EmptyStateWidget(
              icon: Icons.home_repair_service_outlined,
              title: 'No services yet',
              subtitle: 'Add your first service to start accepting bookings',
              action: GradientButton(label: 'Add Service', onPressed: () => context.push(AppRoutes.addService), icon: Icons.add),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: myServices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ServiceListCard(service: myServices[i], ref: ref),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addService),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Service', style: AppTextStyles.button.copyWith(color: Colors.white)),
      ),
    );
  }
}

class _ServiceListCard extends StatelessWidget {
  final ServiceModel service;
  final WidgetRef ref;
  const _ServiceListCard({required this.service, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            gradient: service.isActive ? AppColors.primaryGradient : const LinearGradient(colors: [Color(0xFF374151), Color(0xFF4B5563)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.home_repair_service, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(service.title, style: AppTextStyles.h4, maxLines: 1, overflow: TextOverflow.ellipsis)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: service.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(service.isActive ? 'Active' : 'Inactive',
                style: AppTextStyles.caption.copyWith(color: service.isActive ? AppColors.success : AppColors.error)),
            ),
          ]),
          const SizedBox(height: 4),
          Text(service.category, style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          Row(children: [
            Text(AppFormatters.currency(service.price), style: AppTextStyles.priceSmall),
            const SizedBox(width: 8),
            Text(service.priceUnit, style: AppTextStyles.caption),
            const Spacer(),
            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
            Text(' ${service.rating.toStringAsFixed(1)}', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            // Toggle active
            OutlinedButton.icon(
              onPressed: () {
                ref.read(servicesProvider.notifier).updateService(service.copyWith(isActive: !service.isActive));
              },
              icon: Icon(service.isActive ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 16),
              label: Text(service.isActive ? 'Pause' : 'Activate'),
              style: OutlinedButton.styleFrom(
                foregroundColor: service.isActive ? AppColors.warning : AppColors.success,
                side: BorderSide(color: service.isActive ? AppColors.warning : AppColors.success),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                textStyle: AppTextStyles.buttonSmall,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.editService.replaceAll(':id', service.id), extra: service),
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                textStyle: AppTextStyles.buttonSmall,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _confirmDelete(context, ref, service.id),
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
              padding: EdgeInsets.zero, constraints: const BoxConstraints(),
            ),
          ]),
        ])),
      ]),
    ).animate().fadeIn(duration: 300.ms);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Service'),
      content: const Text('This will permanently delete the service. Continue?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { ref.read(servicesProvider.notifier).deleteService(id); Navigator.pop(context); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
      ],
    ));
  }
}
