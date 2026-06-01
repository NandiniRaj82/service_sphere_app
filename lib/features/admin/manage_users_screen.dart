// ─────────────────────────────────────────────────────────────────────────────
// Manage Users Screen — Admin Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';

class ManageUsersScreen extends ConsumerStatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ConsumerState<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends ConsumerState<ManageUsersScreen> {
  String _search = '';
  List<UserModel> _users = MockDataService.users;

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) =>
      u.name.toLowerCase().contains(_search.toLowerCase()) ||
      u.email.toLowerCase().contains(_search.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: AppTextField(
              label: '', hint: 'Search users...', prefixIcon: Icons.search_rounded,
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Text('${filtered.length} users', style: AppTextStyles.bodySmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${_users.where((u) => !u.isBlocked).length} Active', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${_users.where((u) => u.isBlocked).length} Blocked', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _UserCard(
                user: filtered[i],
                onToggleBlock: () => setState(() {
                  final idx = _users.indexWhere((u) => u.id == filtered[i].id);
                  _users[idx] = _users[idx].copyWith(isBlocked: !_users[idx].isBlocked);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onToggleBlock;
  const _UserCard({required this.user, required this.onToggleBlock});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          AvatarWidget(name: user.name, radius: 24, backgroundColor: user.isBlocked ? AppColors.error : AppColors.primary),
          if (user.isBlocked)
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 12, height: 12,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              ),
            ),
        ]),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(user.name, style: AppTextStyles.h4, overflow: TextOverflow.ellipsis)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: user.isBlocked ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(user.isBlocked ? 'Blocked' : 'Active',
                style: AppTextStyles.caption.copyWith(color: user.isBlocked ? AppColors.error : AppColors.success)),
            ),
          ]),
          const SizedBox(height: 2),
          Text(user.email, style: AppTextStyles.bodySmall),
          Text(user.phone, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text('Joined: ${AppFormatters.date(user.createdAt)}', style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Row(children: [
            OutlinedButton.icon(
              onPressed: onToggleBlock,
              icon: Icon(user.isBlocked ? Icons.lock_open_rounded : Icons.block_rounded, size: 14),
              label: Text(user.isBlocked ? 'Unblock' : 'Block'),
              style: OutlinedButton.styleFrom(
                foregroundColor: user.isBlocked ? AppColors.success : AppColors.error,
                side: BorderSide(color: user.isBlocked ? AppColors.success : AppColors.error),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: AppTextStyles.buttonSmall,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline_rounded, size: 14),
              label: const Text('Details'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: AppTextStyles.buttonSmall,
              ),
            ),
          ]),
        ])),
      ]),
    ).animate().fadeIn(duration: 250.ms);
  }
}
