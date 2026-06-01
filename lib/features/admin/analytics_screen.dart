// ─────────────────────────────────────────────────────────────────────────────
// Analytics Screen — Admin Feature with fl_chart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = MockDataService.adminAnalytics;
    final allBookings = ref.watch(bookingsProvider);
    final categoryData = MockDataService.categoryDistribution;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Revenue stats
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.3,
            children: [
              StatCard(label: 'Total Revenue',   value: AppFormatters.currency(analytics['totalRevenue'] as double), icon: Icons.currency_rupee_rounded, color: AppColors.accent),
              StatCard(label: 'Avg Booking',     value: AppFormatters.currency((analytics['totalRevenue'] as double) / ((analytics['totalBookings'] as int) + 1)), icon: Icons.trending_up_rounded, color: AppColors.success),
              StatCard(label: 'Monthly Growth',  value: '+12.5%', icon: Icons.show_chart_rounded, color: AppColors.primary, subtitle: 'vs last month'),
              StatCard(label: 'Avg Rating',      value: '4.6 ★',  icon: Icons.star_rounded,        color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),

          // Category pie chart
          Text('Service Category Distribution', style: AppTextStyles.h3).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: 12),
          GlassCard(
            child: Row(children: [
              SizedBox(
                height: 180, width: 160,
                child: PieChart(PieChartData(
                  sections: categoryData.entries.map((e) {
                    final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.info, AppColors.warning, const Color(0xFF8B5CF6)];
                    final idx = categoryData.keys.toList().indexOf(e.key);
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      color: colors[idx % colors.length],
                      title: '${e.value}%',
                      titleStyle: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      radius: 70,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 20,
                )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: categoryData.entries.map((e) {
                    final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.info, AppColors.warning, const Color(0xFF8B5CF6)];
                    final idx = categoryData.keys.toList().indexOf(e.key);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[idx % colors.length], shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(e.key, style: AppTextStyles.bodySmall)),
                        Text('${e.value}%', style: AppTextStyles.caption),
                      ]),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ).animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: 20),

          // Booking status pie chart
          Text('Booking Status Overview', style: AppTextStyles.h3).animate(delay: 120.ms).fadeIn(),
          const SizedBox(height: 12),
          GlassCard(
            child: SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                sections: [
                  PieChartSectionData(value: (analytics['completedBookings'] as int).toDouble(), color: AppColors.success, title: 'Done', titleStyle: AppTextStyles.caption.copyWith(color: Colors.white), radius: 80),
                  PieChartSectionData(value: (analytics['activeBookings'] as int).toDouble(),    color: AppColors.warning, title: 'Active', titleStyle: AppTextStyles.caption.copyWith(color: Colors.white), radius: 80),
                  PieChartSectionData(value: ((analytics['totalBookings'] as int) - (analytics['completedBookings'] as int) - (analytics['activeBookings'] as int)).toDouble(), color: AppColors.error.withOpacity(0.7), title: 'Other', titleStyle: AppTextStyles.caption.copyWith(color: Colors.white), radius: 80),
                ],
                sectionsSpace: 3,
                centerSpaceRadius: 25,
              )),
            ),
          ).animate(delay: 150.ms).fadeIn(),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}
