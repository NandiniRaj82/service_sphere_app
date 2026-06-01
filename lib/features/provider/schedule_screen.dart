// ─────────────────────────────────────────────────────────────────────────────
// Schedule Screen — Provider Feature (Calendar view)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay  = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final allBookings = ref.watch(bookingsProvider);
    final myBookings  = allBookings.where((b) =>
      b.providerId == (user?.id ?? 'p1') &&
      (b.status == BookingStatus.confirmed || b.status == BookingStatus.pending)
    ).toList();

    final dayBookings = myBookings.where((b) => isSameDay(b.scheduledAt, _selectedDay)).toList();

    // Build event map for calendar markers
    Map<DateTime, List<BookingModel>> eventMap = {};
    for (final b in myBookings) {
      final key = DateTime(b.scheduledAt.year, b.scheduledAt.month, b.scheduledAt.day);
      eventMap[key] = [...(eventMap[key] ?? []), b];
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('My Schedule')),
      body: Column(
        children: [
          // Calendar
          Padding(
            padding: const EdgeInsets.all(12),
            child: GlassCard(
              child: TableCalendar<BookingModel>(
                firstDay: DateTime.now().subtract(const Duration(days: 30)),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) {
                  final key = DateTime(day.year, day.month, day.day);
                  return eventMap[key] ?? [];
                },
                onDaySelected: (selected, focused) {
                  setState(() { _selectedDay = selected; _focusedDay = focused; });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  markerDecoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  defaultTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  weekendTextStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, titleCentered: true,
                  titleTextStyle: AppTextStyles.h4,
                  leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),

          // Day header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(children: [
              Text(AppFormatters.weekday(_selectedDay), style: AppTextStyles.h3),
              const SizedBox(width: 8),
              Text(AppFormatters.date(_selectedDay), style: AppTextStyles.bodySmall),
              const Spacer(),
              Text('${dayBookings.length} booking(s)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
            ]),
          ),

          // Bookings for selected day
          Expanded(
            child: dayBookings.isEmpty
                ? const EmptyStateWidget(icon: Icons.event_available_rounded, title: 'No bookings on this day')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dayBookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final b = dayBookings[i];
                      return BookingCard(booking: b);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
