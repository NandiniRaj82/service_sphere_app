// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Service Screen — Provider Feature
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class AddEditServiceScreen extends ConsumerStatefulWidget {
  final String? serviceId;
  final ServiceModel? existingService;

  const AddEditServiceScreen({super.key, this.serviceId, this.existingService});

  @override
  ConsumerState<AddEditServiceScreen> createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends ConsumerState<AddEditServiceScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _titleCtrl    = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _priceCtrl    = TextEditingController();
  final _durationCtrl = TextEditingController();
  String _category    = AppStrings.serviceCategories[1];
  String _priceUnit   = 'per visit';
  bool _isFeatured    = false;
  bool _isLoading     = false;

  bool get _isEdit => widget.existingService != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final s = widget.existingService!;
      _titleCtrl.text    = s.title;
      _descCtrl.text     = s.description;
      _priceCtrl.text    = s.price.toStringAsFixed(0);
      _durationCtrl.text = s.durationMinutes.toString();
      _category          = s.category;
      _priceUnit         = s.priceUnit;
      _isFeatured        = s.isFeatured;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _descCtrl.dispose();
    _priceCtrl.dispose(); _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final user = ref.read(currentUserProvider);
    final service = ServiceModel(
      id: _isEdit ? widget.existingService!.id : 'svc_${DateTime.now().millisecondsSinceEpoch}',
      providerId: user?.id ?? 'p1',
      providerName: user?.name ?? 'Provider',
      providerAvatar: '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _category,
      price: double.parse(_priceCtrl.text.trim()),
      priceUnit: _priceUnit,
      durationMinutes: int.parse(_durationCtrl.text.trim()),
      imageUrls: [],
      rating: _isEdit ? widget.existingService!.rating : 0.0,
      reviewCount: _isEdit ? widget.existingService!.reviewCount : 0,
      isActive: true,
      isFeatured: _isFeatured,
      createdAt: _isEdit ? widget.existingService!.createdAt : DateTime.now(),
    );

    if (_isEdit) {
      ref.read(servicesProvider.notifier).updateService(service);
    } else {
      ref.read(servicesProvider.notifier).addService(service);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Service updated!' : 'Service added!'), backgroundColor: AppColors.success),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: Text(_isEdit ? 'Edit Service' : 'Add Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppTextField(
              label: 'Service Title', hint: 'e.g. Home Electrical Repair',
              controller: _titleCtrl, prefixIcon: Icons.home_repair_service_outlined,
              validator: (v) => Validators.minLength(v, 5, fieldName: 'Title'),
            ),
            const SizedBox(height: 14),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _category,
              dropdownColor: AppColors.cardDark,
              decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_outlined)),
              style: AppTextStyles.bodyMedium,
              items: AppStrings.serviceCategories.skip(1).map((cat) =>
                DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 14),

            AppTextField(
              label: 'Description', hint: 'Describe your service in detail...',
              controller: _descCtrl, prefixIcon: Icons.description_outlined, maxLines: 4,
              validator: (v) => Validators.minLength(v, 20, fieldName: 'Description'),
            ),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(
                child: AppTextField(
                  label: 'Price (₹)', hint: '499', controller: _priceCtrl,
                  keyboardType: TextInputType.number, prefixIcon: Icons.currency_rupee_rounded,
                  validator: Validators.price,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _priceUnit,
                  dropdownColor: AppColors.cardDark,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  style: AppTextStyles.bodyMedium,
                  items: ['per visit', 'per hour', 'per item', 'flat', 'per kW', 'per session']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                  onChanged: (v) => setState(() => _priceUnit = v!),
                ),
              ),
            ]),
            const SizedBox(height: 14),

            AppTextField(
              label: 'Duration (minutes)', hint: '60', controller: _durationCtrl,
              keyboardType: TextInputType.number, prefixIcon: Icons.timer_outlined,
              validator: (v) => v == null || v.isEmpty ? 'Duration is required' : null,
            ),
            const SizedBox(height: 16),

            // Featured toggle
            GlassCard(
              child: Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Mark as Featured', style: AppTextStyles.labelLarge),
                  Text('Featured services appear on home screen', style: AppTextStyles.bodySmall),
                ])),
                Switch(
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            GradientButton(
              label: _isEdit ? 'Update Service' : 'Add Service',
              icon: _isEdit ? Icons.save_rounded : Icons.add_rounded,
              isLoading: _isLoading,
              onPressed: _save,
              width: double.infinity,
            ),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}
