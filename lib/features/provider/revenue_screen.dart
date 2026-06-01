// ─────────────────────────────────────────────────────────────────────────────
// Revenue Screen — Provider Feature with fl_chart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';

class RevenueScreen extends ConsumerWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final analytics = MockDataService.getProviderAnalytics(user?.id ?? 'p1');
    final weeklyRevenue = (analytics['weeklyRevenue'] as List<double>);
    final allBookings = ref.watch(bookingsProvider);
    final myPaid = allBookings.where((b) => b.providerId == (user?.id ?? 'p1') && b.isPaid).toList();

    final maxRevenue = weeklyRevenue.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Revenue Overview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Total revenue card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF065F46), Color(0xFF047857)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total Revenue', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(AppFormatters.currency(analytics['revenue'] as double), style: AppTextStyles.displayMedium),
              const SizedBox(height: 16),
              Row(children: [
                _MiniStat('${analytics['totalBookings']}', 'Total'),
                _MiniStat('${analytics['completedBookings']}', 'Done'),
                _MiniStat('${analytics['pendingBookings']}', 'Pending'),
              ]),
            ]),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 20),

          // Weekly bar chart
          Text('Weekly Revenue', style: AppTextStyles.h3).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: 12),
          GlassCard(
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxRevenue * 1.2,
                  barGroups: List.generate(weeklyRevenue.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyRevenue[i],
                          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                          width: 22, borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][v.toInt()],
                            style: AppTextStyles.caption),
                        ),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) => FlLine(color: AppColors.borderDark, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ).animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: 20),

          // Transaction list
          const SectionHeader(title: 'Recent Transactions'),
          const SizedBox(height: 12),
          ...myPaid.take(6).map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.currency_rupee_rounded, color: AppColors.success, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.serviceTitle, style: AppTextStyles.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(b.userName, style: AppTextStyles.caption),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('+${AppFormatters.currency(b.servicePrice)}', style: AppTextStyles.labelLarge.copyWith(color: AppColors.success)),
                  Text(AppFormatters.compact(b.scheduledAt), style: AppTextStyles.caption),
                ]),
              ]),
            ).animate().fadeIn(duration: 250.ms),
          )),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value; final String label;
  const _MiniStat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: AppTextStyles.h2),
    Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white60)),
  ]));
}
