// ─────────────────────────────────────────────────────────────────────────────
// Reviews Screen — Write & Browse Reviews
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../services/mock_data_service.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const ReviewsScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final _commentCtrl = TextEditingController();
  double _myRating = 0;
  bool _submitted = false;

  @override
  void dispose() { _commentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final reviews = MockDataService.reviews.where((r) => r.serviceId == widget.serviceId).toList();
    final avgRating = reviews.isEmpty ? 0.0 : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Reviews & Ratings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating overview
            GlassCard(
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(avgRating.toStringAsFixed(1), style: AppTextStyles.displayMedium.copyWith(color: AppColors.warning)),
                  RatingStars(initialRating: avgRating, size: 20, readOnly: true),
                  const SizedBox(height: 4),
                  Text('${reviews.length} reviews', style: AppTextStyles.bodySmall),
                ]),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final count = reviews.where((r) => r.rating.round() == star).length;
                      final fraction = reviews.isEmpty ? 0.0 : count / reviews.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(children: [
                          Text('$star', style: AppTextStyles.caption),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fraction,
                                backgroundColor: AppColors.borderDark,
                                valueColor: const AlwaysStoppedAnimation(AppColors.warning),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('$count', style: AppTextStyles.caption, textAlign: TextAlign.right),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),

            // Write review
            if (!_submitted) ...[
              Text('Write a Review', style: AppTextStyles.h3).animate(delay: 80.ms).fadeIn(),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your rating', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 8),
                  RatingStars(
                    initialRating: _myRating, size: 36,
                    onRatingChanged: (r) => setState(() => _myRating = r),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Your review', hint: 'Share your experience...', controller: _commentCtrl, maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    label: 'Submit Review', icon: Icons.send_rounded, width: double.infinity,
                    onPressed: _myRating > 0 && _commentCtrl.text.isNotEmpty ? () => setState(() => _submitted = true) : null,
                  ),
                ]),
              ).animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 20),
            ] else ...[
              GlassCard(
                child: Row(children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                  const SizedBox(width: 12),
                  Text('Review submitted! Thank you.', style: AppTextStyles.labelLarge),
                ]),
              ).animate().fadeIn().scale(),
              const SizedBox(height: 20),
            ],

            // Reviews list
            Text('All Reviews (${reviews.length})', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            if (reviews.isEmpty)
              const EmptyStateWidget(icon: Icons.rate_review_outlined, title: 'No reviews yet')
            else
              ...reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      AvatarWidget(name: r.userName, radius: 18, backgroundColor: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.userName, style: AppTextStyles.labelMedium),
                        Text(AppFormatters.timeAgo(r.createdAt), style: AppTextStyles.caption),
                      ])),
                      RatingStars(initialRating: r.rating, size: 16, readOnly: true),
                    ]),
                    const SizedBox(height: 10),
                    Text(r.comment, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ]),
                ).animate().fadeIn(duration: 300.ms),
              )),
          ],
        ),
      ),
    );
  }
}
