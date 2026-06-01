// ─────────────────────────────────────────────────────────────────────────────
// Service Browse Screen — User Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/app_providers.dart';

class ServiceBrowseScreen extends ConsumerStatefulWidget {
  const ServiceBrowseScreen({super.key});

  @override
  ConsumerState<ServiceBrowseScreen> createState() => _ServiceBrowseScreenState();
}

class _ServiceBrowseScreenState extends ConsumerState<ServiceBrowseScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesProvider);
    final notifier = ref.read(servicesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Browse Services'),
        actions: [
          IconButton(
            onPressed: () {}, // Filter dialog
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: AppTextField(
              label: '', hint: AppStrings.searchServices,
              controller: _searchCtrl,
              prefixIcon: Icons.search_rounded,
              onChanged: notifier.search,
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppStrings.serviceCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = AppStrings.serviceCategories[i];
                return CategoryChip(
                  label: cat,
                  isSelected: servicesState.selectedCategory == cat,
                  onTap: () => notifier.filterByCategory(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('${servicesState.filtered.length} services found', style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          // Service list
          Expanded(
            child: servicesState.isLoading
                ? _SkeletonGrid()
                : servicesState.filtered.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No services found',
                        subtitle: 'Try a different search or category',
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: servicesState.filtered.length,
                        itemBuilder: (_, i) {
                          final s = servicesState.filtered[i];
                          return ServiceCard(
                            service: s,
                            onTap: () => context.push(AppRoutes.serviceDetail.replaceAll(':id', s.id)),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
      childAspectRatio: 0.68,
      children: const [
        ServiceCardSkeleton(), ServiceCardSkeleton(),
        ServiceCardSkeleton(), ServiceCardSkeleton(),
      ],
    );
  }
}
