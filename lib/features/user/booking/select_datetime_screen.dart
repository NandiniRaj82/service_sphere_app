// ─────────────────────────────────────────────────────────────────────────────
// Booking Flow — Select Date & Time Screen
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../models/service_model.dart';
import '../../../services/mock_data_service.dart';

class SelectDateTimeScreen extends StatefulWidget {
  final ServiceModel service;
  const SelectDateTimeScreen({super.key, required this.service});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime _focusedDay  = DateTime.now();
  DateTime _selectedDay = DateTime.now().add(const Duration(days: 1));
  String?  _selectedTime;
  final _timeSlots = MockDataService.getAvailableTimeSlots(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Select Date & Time')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service summary
            GlassCard(
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.home_repair_service, color: AppColors.primaryLight, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.service.title, style: AppTextStyles.h4),
                  Text(widget.service.providerName, style: AppTextStyles.bodySmall),
                ])),
                Text(AppFormatters.currency(widget.service.price), style: AppTextStyles.priceSmall),
              ]),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),

            // Calendar
            Text('Select Date', style: AppTextStyles.h3).animate(delay: 80.ms).fadeIn(),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 60)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() { _selectedDay = selected; _focusedDay = focused; _selectedTime = null; });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  defaultTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  weekendTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  outsideTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  disabledTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.borderDark),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: AppTextStyles.h4,
                  leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  weekendStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),
            const SizedBox(height: 20),

            // Time slots
            Text('Select Time', style: AppTextStyles.h3).animate(delay: 150.ms).fadeIn(),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8, mainAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTime == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = slot),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderDark),
                    ),
                    alignment: Alignment.center,
                    child: Text(slot, style: AppTextStyles.labelMedium.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
                  ),
                );
              }).toList(),
            ).animate(delay: 180.ms).fadeIn(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: const Border(top: BorderSide(color: AppColors.borderDark)),
        ),
        child: SafeArea(
          child: GradientButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            width: double.infinity,
            onPressed: _selectedTime == null ? null : () {
              final parts = _selectedTime!.split(':');
              final hour  = int.parse(parts[0]);
              final isPM  = _selectedTime!.contains('PM') && hour != 12;
              final scheduledAt = DateTime(
                _selectedDay.year, _selectedDay.month, _selectedDay.day,
                isPM ? hour + 12 : hour, int.parse(parts[1].split(' ')[0]),
              );
              context.push(AppRoutes.bookingSummary, extra: {
                'service': widget.service,
                'scheduledAt': scheduledAt,
                'timeSlot': _selectedTime,
              });
            },
          ),
        ),
      ),
    );
  }
}
