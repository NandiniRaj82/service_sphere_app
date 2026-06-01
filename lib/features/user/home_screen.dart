// ─────────────────────────────────────────────────────────────────────────────
// Home Screen — User Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';



class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _categories = [
    ('Cleaning',       Icons.cleaning_services_rounded,  Color(0xFF5B21B6)),
    ('Plumbing',       Icons.plumbing_rounded,           Color(0xFF0F766E)),
    ('Electrical',     Icons.electrical_services_rounded,Color(0xFFF59E0B)),
    ('Carpentry',      Icons.handyman_rounded,           Color(0xFFDC2626)),
    ('Car Service',    Icons.directions_car_rounded,     Color(0xFF1D4ED8)),
    ('Gardening',      Icons.yard_rounded,               Color(0xFF059669)),
    ('Solar',          Icons.wb_sunny_rounded,           Color(0xFFD97706)),
    ('Appliance Repair',Icons.kitchen_rounded,           Color(0xFF7C3AED)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user     = ref.watch(currentUserProvider);
    final services = ref.watch(servicesProvider);
    final featured = services.all.where((s) => s.isFeatured && s.isActive).toList();
    final recommended = user != null ? MockDataService.getRecommendations(user.id) : featured.take(3).toList();
    final unread   = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B0764), Color(0xFF1A1A2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Good day, 👋', style: AppTextStyles.bodySmall),
                                  Text(
                                    user?.name.split(' ').first ?? 'Friend',
                                    style: AppTextStyles.displaySmall,
                                  ),
                                ],
                              ),
                            ),
                            // Notifications
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  onPressed: () => context.push(AppRoutes.notifications),
                                  icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                                ),
                                if (unread > 0)
                                  Positioned(
                                    top: 6, right: 6,
                                    child: Container(
                                      width: 16, height: 16,
                                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                      child: Center(
                                        child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            AvatarWidget(name: user?.name ?? 'U', radius: 22),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Search Bar ────────────────────────────────────────────
                GestureDetector(
                  onTap: () => context.go(AppRoutes.services),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 10),
                        Text(AppStrings.searchServices, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 24),

                // ── Categories ────────────────────────────────────────────
                const SectionHeader(title: 'Categories'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: _categories.map((cat) => _CategoryItem(
                    label: cat.$1, icon: cat.$2, color: cat.$3,
                    onTap: () => context.go(AppRoutes.services),
                  )).toList(),
                ),
                const SizedBox(height: 24),

                // ── Featured Services ─────────────────────────────────────
                SectionHeader(
                  title: AppStrings.featuredServices,
                  actionLabel: AppStrings.viewAll,
                  onAction: () => context.go(AppRoutes.services),
                ),
                const SizedBox(height: 12),

                if (services.isLoading)
                  const SizedBox(
                    height: 220,
                    child: Row(children: [
                      Expanded(child: ServiceCardSkeleton()),
                      SizedBox(width: 12),
                      Expanded(child: ServiceCardSkeleton()),
                    ]),
                  )
                else
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => SizedBox(
                        width: 200,
                        child: ServiceCard(
                          service: featured[i],
                          onTap: () => context.push(
                            AppRoutes.serviceDetail.replaceAll(':id', featured[i].id),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // ── AI Recommendations ────────────────────────────────────
                _AiRecommendationsSection(services: recommended, onTap: (s) {
                  context.push(AppRoutes.serviceDetail.replaceAll(':id', s.id));
                }),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryItem({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label, style: AppTextStyles.caption, textAlign: TextAlign.center,
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class _AiRecommendationsSection extends StatelessWidget {
  final List<ServiceModel> services;
  final void Function(ServiceModel) onTap;
  const _AiRecommendationsSection({required this.services, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(AppStrings.recommended, style: AppTextStyles.h2),
          ],
        ),
        const SizedBox(height: 6),
        Text('Personalized picks based on your bookings', style: AppTextStyles.bodySmall),
        const SizedBox(height: 12),
        ...services.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _HorizontalServiceCard(service: s, onTap: () => onTap(s)),
        )),
      ],
    );
  }
}

class _HorizontalServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  const _HorizontalServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_iconFor(service.category), color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.title, style: AppTextStyles.h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(service.providerName, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text(service.rating.toStringAsFixed(1), style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('AI Pick', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 0,
            child: Text(AppFormatters.currency(service.price), style: AppTextStyles.priceSmall, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
  }

  IconData _iconFor(String cat) {
    switch (cat) {
      case 'Electrical': return Icons.electrical_services; case 'Cleaning': return Icons.cleaning_services;
      case 'Plumbing': return Icons.plumbing; case 'Gardening': return Icons.yard;
      case 'Solar': return Icons.wb_sunny; case 'Car Service': return Icons.directions_car;
      default: return Icons.home_repair_service;
    }
  }
}
