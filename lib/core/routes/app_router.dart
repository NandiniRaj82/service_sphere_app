// ─────────────────────────────────────────────────────────────────────────────
// App Router — Service Sphere (GoRouter with role-based guards)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../models/service_model.dart';
import '../../providers/auth_provider.dart';

// Auth screens
import '../../features/auth/splash_screen.dart';
import '../../features/auth/role_select_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/forgot_password_screen.dart';

// User screens
import '../../features/user/home_screen.dart';
import '../../features/user/service_browse_screen.dart';
import '../../features/user/service_detail_screen.dart';
import '../../features/user/booking/select_datetime_screen.dart';
import '../../features/user/booking/booking_summary_screen.dart';
import '../../features/user/booking/payment_screen.dart';
import '../../features/user/booking/booking_confirmation_screen.dart';
import '../../features/user/booking_history_screen.dart';
import '../../features/user/track_booking_screen.dart';
import '../../features/user/profile_screen.dart';
import '../../features/user/notifications_screen.dart';
import '../../features/user/chat_screen.dart';
import '../../features/user/reviews_screen.dart';

// Provider screens
import '../../features/provider/provider_dashboard.dart';
import '../../features/provider/manage_services_screen.dart';
import '../../features/provider/add_edit_service_screen.dart';
import '../../features/provider/booking_requests_screen.dart';
import '../../features/provider/schedule_screen.dart';
import '../../features/provider/revenue_screen.dart';
import '../../features/provider/customer_management_screen.dart';

// Admin screens
import '../../features/admin/admin_dashboard.dart';
import '../../features/admin/manage_users_screen.dart';
import '../../features/admin/manage_providers_screen.dart';
import '../../features/admin/admin_manage_services_screen.dart';
import '../../features/admin/analytics_screen.dart';
import '../../features/admin/role_management_screen.dart';
import '../../features/admin/activity_logs_screen.dart';

// Shell layouts
import '../../features/user/user_shell.dart';
import '../../features/provider/provider_shell.dart';
import '../../features/admin/admin_shell.dart';

// ── Route Names ────────────────────────────────────────────────────────────
class AppRoutes {
  static const splash      = '/';
  static const roleSelect  = '/role-select';
  static const login       = '/login';
  static const signup      = '/signup';
  static const forgotPass  = '/forgot-password';

  // User
  static const userHome         = '/user/home';
  static const services         = '/user/services';
  static const serviceDetail    = '/user/service/:id';
  static const selectDateTime   = '/user/book/datetime';
  static const bookingSummary   = '/user/book/summary';
  static const payment          = '/user/book/payment';
  static const bookingConfirm   = '/user/book/confirm';
  static const bookingHistory   = '/user/bookings';
  static const trackBooking     = '/user/track/:id';
  static const userProfile      = '/user/profile';
  static const notifications    = '/user/notifications';
  static const userChat         = '/user/chat/:roomId';
  static const reviews          = '/user/reviews/:serviceId';

  // Provider
  static const providerDashboard   = '/provider/dashboard';
  static const manageServices      = '/provider/services';
  static const addService          = '/provider/services/add';
  static const editService         = '/provider/services/edit/:id';
  static const bookingRequests     = '/provider/requests';
  static const schedule            = '/provider/schedule';
  static const revenue             = '/provider/revenue';
  static const customers           = '/provider/customers';
  static const providerChat        = '/provider/chat/:roomId';

  // Admin
  static const adminDashboard   = '/admin/dashboard';
  static const manageUsers      = '/admin/users';
  static const manageProviders  = '/admin/providers';
  static const adminServices    = '/admin/services';
  static const analytics        = '/admin/analytics';
  static const roleManagement   = '/admin/roles';
  static const activityLogs     = '/admin/logs';
}

// ── Router Provider ────────────────────────────────────────────────────────
//
// IMPORTANT: GoRouter must NOT be recreated on every auth state change.
// We use a RouterNotifier (ChangeNotifier) that listens to Riverpod's
// authProvider and calls notifyListeners() — GoRouter's refreshListenable
// will then re-evaluate the redirect without rebuilding the router.
//
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late AuthState _authState;

  _RouterNotifier(this._ref) {
    _authState = _ref.read(authProvider);
    _ref.listen<AuthState>(authProvider, (_, next) {
      _authState = next;
      notifyListeners();
    });
  }

  AuthState get authState => _authState;
}

final _routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  return _RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState    = notifier.authState;
      final isLoading    = authState.status == AuthStatus.initial || authState.isLoading;
      final isAuth       = authState.isAuthenticated;
      final role         = authState.user?.role;
      final location     = state.uri.path;

      // Always let splash render — it navigates itself once auth resolves
      if (location == AppRoutes.splash) return null;

      // If still loading, send back to splash
      if (isLoading) return AppRoutes.splash;

      final authPages = [AppRoutes.roleSelect, AppRoutes.login, AppRoutes.signup, AppRoutes.forgotPass];
      final isAuthPage = authPages.any((r) => location.startsWith(r));

      if (!isAuth && !isAuthPage) return AppRoutes.roleSelect;
      if (isAuth && isAuthPage)   return _homeForRole(role);

      // Role-based path enforcement
      if (isAuth) {
        if (location.startsWith('/user')     && role != UserRole.user)     return _homeForRole(role);
        if (location.startsWith('/provider') && role != UserRole.provider) return _homeForRole(role);
        if (location.startsWith('/admin')    && role != UserRole.admin)    return _homeForRole(role);
      }

      return null;
    },
    routes: [
      // ── Auth ─────────────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.splash,     builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.roleSelect, builder: (_, __) => const RoleSelectScreen()),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) {
          final role = state.uri.queryParameters['role'] ?? 'user';
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (_, state) {
          final role = state.uri.queryParameters['role'] ?? 'user';
          return SignupScreen(role: role);
        },
      ),
      GoRoute(path: AppRoutes.forgotPass, builder: (_, __) => const ForgotPasswordScreen()),

      // ── User Shell (bottom nav) ────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => UserShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.userHome,       builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.services,       builder: (_, __) => const ServiceBrowseScreen()),
          GoRoute(path: AppRoutes.bookingHistory, builder: (_, __) => const BookingHistoryScreen()),
          GoRoute(path: AppRoutes.userProfile,    builder: (_, __) => const UserProfileScreen()),
        ],
      ),

      // ── User standalone routes ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.serviceDetail,
        builder: (_, state) => ServiceDetailScreen(serviceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.selectDateTime,
        builder: (_, state) => SelectDateTimeScreen(service: state.extra as ServiceModel),
      ),
      GoRoute(
        path: AppRoutes.bookingSummary,
        builder: (_, state) => BookingSummaryScreen(bookingData: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, state) => PaymentScreen(bookingData: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: AppRoutes.bookingConfirm,
        builder: (_, state) => BookingConfirmationScreen(bookingData: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: AppRoutes.trackBooking,
        builder: (_, state) => TrackBookingScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.userChat,
        builder: (_, state) => ChatScreen(
          chatRoomId: state.pathParameters['roomId']!,
          extra: state.extra as Map<String, dynamic>? ?? {},
        ),
      ),
      GoRoute(
        path: AppRoutes.reviews,
        builder: (_, state) => ReviewsScreen(serviceId: state.pathParameters['serviceId']!),
      ),

      // ── Provider Shell ─────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ProviderShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.providerDashboard, builder: (_, __) => const ProviderDashboard()),
          GoRoute(path: AppRoutes.manageServices,    builder: (_, __) => const ManageServicesScreen()),
          GoRoute(path: AppRoutes.bookingRequests,   builder: (_, __) => const BookingRequestsScreen()),
          GoRoute(path: AppRoutes.schedule,          builder: (_, __) => const ScheduleScreen()),
          GoRoute(path: AppRoutes.revenue,           builder: (_, __) => const RevenueScreen()),
          GoRoute(path: AppRoutes.customers,         builder: (_, __) => const CustomerManagementScreen()),
        ],
      ),
      GoRoute(path: AppRoutes.addService,  builder: (_, __) => const AddEditServiceScreen()),
      GoRoute(
        path: AppRoutes.editService,
        builder: (_, state) => AddEditServiceScreen(
          serviceId: state.pathParameters['id'],
          existingService: state.extra as ServiceModel?,
        ),
      ),
      GoRoute(
        path: AppRoutes.providerChat,
        builder: (_, state) => ChatScreen(
          chatRoomId: state.pathParameters['roomId']!,
          extra: state.extra as Map<String, dynamic>? ?? {},
        ),
      ),

      // ── Admin Shell ────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.adminDashboard,  builder: (_, __) => const AdminDashboard()),
          GoRoute(path: AppRoutes.manageUsers,     builder: (_, __) => const ManageUsersScreen()),
          GoRoute(path: AppRoutes.manageProviders, builder: (_, __) => const ManageProvidersScreen()),
          GoRoute(path: AppRoutes.adminServices,   builder: (_, __) => const AdminManageServicesScreen()),
          GoRoute(path: AppRoutes.analytics,       builder: (_, __) => const AnalyticsScreen()),
          GoRoute(path: AppRoutes.roleManagement,  builder: (_, __) => const RoleManagementScreen()),
          GoRoute(path: AppRoutes.activityLogs,    builder: (_, __) => const ActivityLogsScreen()),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  );
});

String _homeForRole(UserRole? role) {
  switch (role) {
    case UserRole.provider: return AppRoutes.providerDashboard;
    case UserRole.admin:    return AppRoutes.adminDashboard;
    default:                return AppRoutes.userHome;
  }
}

