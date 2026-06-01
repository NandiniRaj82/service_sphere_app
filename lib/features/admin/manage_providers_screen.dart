// ─────────────────────────────────────────────────────────────────────────────
// Manage Providers Screen — Admin Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';

class ManageProvidersScreen extends StatefulWidget {
  const ManageProvidersScreen({super.key});

  @override
  State<ManageProvidersScreen> createState() => _ManageProvidersScreenState();
}

class _ManageProvidersScreenState extends State<ManageProvidersScreen> {
  List<UserModel> _providers = List.from(MockDataService.providers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _providers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final p = _providers[i];
          return GlassCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                AvatarWidget(name: p.name, radius: 24, backgroundColor: p.isActive ? AppColors.info : AppColors.textMuted),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: AppTextStyles.h4, overflow: TextOverflow.ellipsis),
                  Text(p.email, style: AppTextStyles.caption),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.isActive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(p.isActive ? 'Approved' : 'Pending',
                    style: AppTextStyles.caption.copyWith(color: p.isActive ? AppColors.success : AppColors.error)),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(p.phone, style: AppTextStyles.bodySmall),
                const Spacer(),
                Text('Since ${AppFormatters.date(p.createdAt)}', style: AppTextStyles.caption),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                if (!p.isActive)
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => setState(() { _providers[i] = p.copyWith(isActive: true); }),
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success.withOpacity(0.2), foregroundColor: AppColors.success, elevation: 0),
                  )),
                if (p.isActive)
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => setState(() { _providers[i] = p.copyWith(isActive: false); }),
                    icon: const Icon(Icons.block_rounded, size: 16),
                    label: const Text('Suspend'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                  )),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('View Profile'),
                ),
              ]),
            ]),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
        },
      ),
    );
  }
}
