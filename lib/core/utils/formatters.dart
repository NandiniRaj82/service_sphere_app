// ─────────────────────────────────────────────────────────────────────────────
// Formatters & Date Helpers — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final _currency   = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
  static final _date       = DateFormat('dd MMM yyyy');
  static final _dateTime   = DateFormat('dd MMM yyyy, hh:mm a');
  static final _time       = DateFormat('hh:mm a');
  static final _dayMonth   = DateFormat('dd MMM');
  static final _weekday    = DateFormat('EEEE');
  static final _monthYear  = DateFormat('MMMM yyyy');
  static final _compact    = DateFormat('dd/MM/yy');

  static String currency(double amount) => _currency.format(amount);
  static String date(DateTime dt)       => _date.format(dt);
  static String dateTime(DateTime dt)   => _dateTime.format(dt);
  static String time(DateTime dt)       => _time.format(dt);
  static String dayMonth(DateTime dt)   => _dayMonth.format(dt);
  static String weekday(DateTime dt)    => _weekday.format(dt);
  static String monthYear(DateTime dt)  => _monthYear.format(dt);
  static String compact(DateTime dt)    => _compact.format(dt);

  /// Returns "2 hours ago", "3 days ago", etc.
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60)  return 'Just now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)    return '${diff.inHours}h ago';
    if (diff.inDays < 7)      return '${diff.inDays}d ago';
    if (diff.inDays < 30)     return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365)    return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// Abbreviates large numbers: 1200 -> "1.2K"
  static String compactNumber(num value) {
    if (value >= 1e6)  return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value >= 1e3)  return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}
