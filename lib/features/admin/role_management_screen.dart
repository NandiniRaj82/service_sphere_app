// ─────────────────────────────────────────────────────────────────────────────
// Role Management Screen — Admin Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  List<UserModel> _users = [...MockDataService.users, ...MockDataService.providers];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final u = _users[i];
          return GlassCard(
            child: Row(children: [
              AvatarWidget(name: u.name, radius: 22, backgroundColor: _roleColor(u.role)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(u.name, style: AppTextStyles.h4, overflow: TextOverflow.ellipsis),
                Text(u.email, style: AppTextStyles.caption),
              ])),
              const SizedBox(width: 8),
              // Role dropdown
              DropdownButton<UserRole>(
                value: u.role,
                dropdownColor: AppColors.cardDark,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                items: UserRole.values.map((r) => DropdownMenuItem(
                  value: r,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _roleColor(r).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(r.label, style: AppTextStyles.caption.copyWith(color: _roleColor(r))),
                  ),
                )).toList(),
                onChanged: (newRole) {
                  if (newRole != null) {
                    setState(() { _users[i] = u.copyWith(role: newRole); });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${u.name} role updated to ${newRole.label}'), backgroundColor: AppColors.success),
                    );
                  }
                },
              ),
            ]),
          ).animate().fadeIn(duration: 250.ms);
        },
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:    return AppColors.error;
      case UserRole.provider: return AppColors.info;
      default:                return AppColors.primary;
    }
  }
}
