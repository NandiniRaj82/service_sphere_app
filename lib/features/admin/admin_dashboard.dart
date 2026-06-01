// ─────────────────────────────────────────────────────────────────────────────
// Admin Dashboard
// ─────────────────────────────────────────────────────────────────────────────

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../providers/app_providers.dart';
import '../../services/mock_data_service.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = MockDataService.adminAnalytics;
    final allBookings = ref.watch(bookingsProvider);
    final allServices = ref.watch(servicesProvider).all;
    final monthlyRevenue = (analytics['monthlyRevenue'] as List<double>);
    final maxRev = monthlyRevenue.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF3B0764), Color(0xFF1A1A2E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('Admin Dashboard', style: AppTextStyles.displaySmall),
                      Text('Platform overview', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ]),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // KPI stats
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2,
                children: [
                  StatCard(label: 'Total Users',    value: '${analytics['totalUsers']}',    icon: Icons.people_rounded,          color: AppColors.primary),
                  StatCard(label: 'Providers',      value: '${analytics['totalProviders']}',icon: Icons.home_repair_service,     color: AppColors.info),
                  StatCard(label: 'Total Services', value: '${allServices.length}',         icon: Icons.design_services_rounded, color: AppColors.success),
                  StatCard(label: 'Total Revenue',  value: AppFormatters.currency(analytics['totalRevenue'] as double), icon: Icons.currency_rupee_rounded, color: AppColors.accent),
                ],
              ),
              const SizedBox(height: 16),

              // Booking stats row
              Row(children: [
                Expanded(child: StatCard(label: 'Total Bookings',  value: '${analytics['totalBookings']}',   icon: Icons.calendar_today, color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(label: 'Active',          value: '${analytics['activeBookings']}',  icon: Icons.pending_actions, color: AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(label: 'Completed',       value: '${analytics['completedBookings']}',icon: Icons.check_circle, color: AppColors.success)),
              ]),
              const SizedBox(height: 20),

              // Revenue chart
              const SectionHeader(title: 'Monthly Revenue'),
              const SizedBox(height: 12),
              GlassCard(
                child: SizedBox(
                  height: 180,
                  child: LineChart(LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(monthlyRevenue.length, (i) => FlSpot(i.toDouble(), monthlyRevenue[i])),
                        isCurved: true,
                        gradient: AppColors.primaryGradient,
                        barWidth: 3,
                        dotData: FlDotData(
                          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: AppColors.primaryLight, strokeColor: Colors.transparent),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][v.toInt()],
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (_) => FlLine(color: AppColors.borderDark, strokeWidth: 1),
                      getDrawingVerticalLine: (_) => FlLine(color: AppColors.borderDark, strokeWidth: 0),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 0, maxY: maxRev * 1.3,
                  )),
                ),
              ).animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 20),

              // Quick actions
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
                children: [
                  _ActionCard(icon: Icons.people_rounded,          label: 'Users',     color: AppColors.primary, onTap: () => context.go(AppRoutes.manageUsers)),
                  _ActionCard(icon: Icons.home_repair_service,     label: 'Providers', color: AppColors.info,    onTap: () => context.go(AppRoutes.manageProviders)),
                  _ActionCard(icon: Icons.design_services_rounded, label: 'Services',  color: AppColors.success, onTap: () => context.go(AppRoutes.adminServices)),
                  _ActionCard(icon: Icons.bar_chart_rounded,       label: 'Analytics', color: AppColors.accent,  onTap: () => context.go(AppRoutes.analytics)),
                  _ActionCard(icon: Icons.manage_accounts_rounded, label: 'Roles',     color: AppColors.warning, onTap: () => context.go(AppRoutes.roleManagement)),
                  _ActionCard(icon: Icons.history_rounded,         label: 'Logs',      color: AppColors.statusCompleted, onTap: () => context.go(AppRoutes.activityLogs)),
                ],
              ),
              const SizedBox(height: 20),

              // Recent activity
              const SectionHeader(title: 'Recent Activity'),
              const SizedBox(height: 12),
              ...MockDataService.activityLogs.take(5).map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  child: Row(children: [
                    const Icon(Icons.circle, size: 8, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(log['action'] as String, style: AppTextStyles.bodySmall)),
                    const SizedBox(width: 8),
                    Text(AppFormatters.timeAgo(log['time'] as DateTime), style: AppTextStyles.caption),
                  ]),
                ).animate().fadeIn(duration: 250.ms),
              )),
              const SizedBox(height: 80),
            ])),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
      ]),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
