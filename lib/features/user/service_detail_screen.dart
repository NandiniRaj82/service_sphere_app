// ─────────────────────────────────────────────────────────────────────────────
// Service Detail Screen — User Feature
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
import '../../models/review_model.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesState = ref.watch(servicesProvider);
    final service = servicesState.all.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => servicesState.all.first,
    );
    final reviews = MockDataService.reviews.where((r) => r.serviceId == serviceId).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // ── Hero image ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.8), AppColors.accent.withOpacity(0.5)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(_categoryIcon(service.category), color: Colors.white.withOpacity(0.3), size: 100),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Category & featured badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(service.category, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryLight)),
                    ),
                    if (service.isFeatured) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Featured', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                      ),
                    ],
                  ],
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 12),

                // Title
                Text(service.title, style: AppTextStyles.displaySmall)
                    .animate(delay: 80.ms).fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: 8),

                // Provider
                Row(
                  children: [
                    AvatarWidget(name: service.providerName, radius: 16, backgroundColor: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Text(service.providerName, style: AppTextStyles.labelMedium),
                  ],
                ).animate(delay: 100.ms).fadeIn(),
                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    _InfoChip(icon: Icons.star_rounded, label: '${service.rating} (${service.reviewCount})', color: AppColors.warning),
                    const SizedBox(width: 12),
                    _InfoChip(icon: Icons.access_time, label: service.durationLabel, color: AppColors.info),
                    const SizedBox(width: 12),
                    _InfoChip(icon: Icons.attach_money, label: service.priceUnit, color: AppColors.success),
                  ],
                ).animate(delay: 120.ms).fadeIn(),
                const SizedBox(height: 20),

                // Description
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About this Service', style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      Text(service.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6)),
                    ],
                  ),
                ).animate(delay: 150.ms).fadeIn(),
                const SizedBox(height: 16),

                // Tags
                if (service.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: service.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Text('#$t', style: AppTextStyles.caption),
                    )).toList(),
                  ).animate(delay: 180.ms).fadeIn(),
                  const SizedBox(height: 20),
                ],

                // Reviews section
                SectionHeader(
                  title: 'Reviews (${reviews.length})',
                  actionLabel: reviews.isNotEmpty ? 'See All' : null,
                  onAction: () => context.push(AppRoutes.reviews.replaceAll(':serviceId', serviceId)),
                ),
                const SizedBox(height: 12),
                if (reviews.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: EmptyStateWidget(icon: Icons.rate_review_outlined, title: 'No reviews yet'),
                  )
                else
                  ...reviews.take(2).map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReviewCard(review: r),
                  )),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),

      // ── Book Now button ─────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: const Border(top: BorderSide(color: AppColors.borderDark)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppFormatters.currency(service.price), style: AppTextStyles.price),
                  Text(service.priceUnit, style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GradientButton(
                  label: 'Book Now',
                  icon: Icons.calendar_month_rounded,
                  onPressed: () => context.push(AppRoutes.selectDateTime, extra: service),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Electrical': return Icons.electrical_services;
      case 'Cleaning': return Icons.cleaning_services;
      case 'Plumbing': return Icons.plumbing;
      case 'Gardening': return Icons.yard;
      case 'Solar': return Icons.wb_sunny;
      case 'Car Service': return Icons.directions_car;
      default: return Icons.home_repair_service;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    ]),
  );
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          AvatarWidget(name: review.userName, radius: 18, backgroundColor: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(review.userName, style: AppTextStyles.labelMedium),
            Text(AppFormatters.timeAgo(review.createdAt), style: AppTextStyles.caption),
          ])),
          RatingStars(initialRating: review.rating, size: 16, readOnly: true),
        ]),
        const SizedBox(height: 10),
        Text(review.comment, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ]),
    );
  }
}
