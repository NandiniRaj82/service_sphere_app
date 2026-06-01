// ─────────────────────────────────────────────────────────────────────────────
// Activity Logs Screen — Admin Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../services/mock_data_service.dart';

class ActivityLogsScreen extends StatelessWidget {
  const ActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = MockDataService.activityLogs;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final log   = logs[i];
          final action = log['action'] as String;
          final time   = log['time'] as DateTime;
          final user   = log['user'] as String;
          final type   = log['type'] as String;

          return GlassCard(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _colorFor(type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_iconFor(type), color: _colorFor(type), size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(action, style: AppTextStyles.labelMedium),
                  const SizedBox(height: 2),
                  Text('by $user', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(AppFormatters.timeAgo(time), style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _colorFor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(type.toUpperCase(), style: AppTextStyles.caption.copyWith(color: _colorFor(type), fontSize: 9)),
                ),
              ]),
            ]),
          ).animate().fadeIn(duration: 200.ms);
        },
      ),
    );
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'booking':  return AppColors.primary;
      case 'user':     return AppColors.info;
      case 'payment':  return AppColors.success;
      case 'service':  return AppColors.warning;
      case 'admin':    return AppColors.error;
      default:         return AppColors.textMuted;
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'booking':  return Icons.calendar_today_rounded;
      case 'user':     return Icons.person_rounded;
      case 'payment':  return Icons.payment_rounded;
      case 'service':  return Icons.home_repair_service;
      case 'admin':    return Icons.admin_panel_settings_rounded;
      default:         return Icons.circle;
    }
  }
}
