// ─────────────────────────────────────────────────────────────────────────────
// App Strings — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

class AppStrings {
  AppStrings._();

  // App
  static const String appName        = 'Service Sphere';
  static const String appTagline     = 'Expert services, at your doorstep';
  static const String appVersion     = '1.0.0';

  // Roles
  static const String roleUser       = 'user';
  static const String roleProvider   = 'provider';
  static const String roleAdmin      = 'admin';

  // Auth
  static const String login          = 'Login';
  static const String signup         = 'Sign Up';
  static const String logout         = 'Logout';
  static const String email          = 'Email';
  static const String password       = 'Password';
  static const String confirmPass    = 'Confirm Password';
  static const String fullName       = 'Full Name';
  static const String phone          = 'Phone Number';
  static const String forgotPass     = 'Forgot Password?';
  static const String resetPass      = 'Reset Password';
  static const String sendReset      = 'Send Reset Email';
  static const String noAccount      = "Don't have an account?";
  static const String hasAccount     = 'Already have an account?';
  static const String continueAs     = 'Continue as';
  static const String selectRole     = 'Choose Your Role';
  static const String selectRoleSub  = 'How will you be using Service Sphere?';

  // Navigation
  static const String home           = 'Home';
  static const String services       = 'Services';
  static const String bookings       = 'Bookings';
  static const String profile        = 'Profile';
  static const String dashboard      = 'Dashboard';
  static const String notifications  = 'Notifications';
  static const String chat           = 'Chat';

  // User
  static const String browseServices = 'Browse Services';
  static const String featuredServices = 'Featured Services';
  static const String nearbyServices = 'Nearby Services';
  static const String recommended    = 'Recommended for You';
  static const String searchServices = 'Search services...';
  static const String allCategories  = 'All Categories';
  static const String bookNow        = 'Book Now';
  static const String viewDetails    = 'View Details';
  static const String selectDate     = 'Select Date & Time';
  static const String bookingSummary = 'Booking Summary';
  static const String confirmBooking = 'Confirm Booking';
  static const String paymentDetails = 'Payment Details';
  static const String payNow         = 'Pay Now';
  static const String bookingHistory = 'Booking History';
  static const String trackBooking   = 'Track Booking';
  static const String writeReview    = 'Write a Review';
  static const String submitReview   = 'Submit Review';

  // Provider
  static const String providerDashboard = 'Provider Dashboard';
  static const String manageServices  = 'Manage Services';
  static const String addService      = 'Add Service';
  static const String editService     = 'Edit Service';
  static const String bookingRequests = 'Booking Requests';
  static const String mySchedule      = 'My Schedule';
  static const String revenue         = 'Revenue';
  static const String customers       = 'Customers';
  static const String acceptBooking   = 'Accept';
  static const String rejectBooking   = 'Reject';

  // Admin
  static const String adminDashboard  = 'Admin Dashboard';
  static const String manageUsers     = 'Manage Users';
  static const String manageProviders = 'Manage Providers';
  static const String analytics       = 'Analytics';
  static const String roleManagement  = 'Role Management';
  static const String activityLogs    = 'Activity Logs';
  static const String approveProvider = 'Approve';
  static const String rejectProvider  = 'Reject';
  static const String blockUser       = 'Block';
  static const String unblockUser     = 'Unblock';

  // Status
  static const String pending    = 'Pending';
  static const String confirmed  = 'Confirmed';
  static const String rejected   = 'Rejected';
  static const String completed  = 'Completed';
  static const String cancelled  = 'Cancelled';
  static const String active     = 'Active';
  static const String inactive   = 'Inactive';

  // Categories
  static const List<String> serviceCategories = [
    'All', 'Cleaning', 'Plumbing', 'Electrical', 'Carpentry',
    'Painting', 'Appliance Repair', 'Car Service', 'Gardening',
    'Security', 'Water Supply', 'Solar',
  ];

  // Empty states
  static const String noBookings     = 'No bookings yet';
  static const String noServices     = 'No services available';
  static const String noNotifications = 'No notifications';
  static const String noMessages     = 'No messages yet';

  // Misc
  static const String viewAll        = 'View All';
  static const String save           = 'Save';
  static const String cancel         = 'Cancel';
  static const String delete         = 'Delete';
  static const String edit           = 'Edit';
  static const String back           = 'Back';
  static const String loading        = 'Loading...';
  static const String retry          = 'Retry';
  static const String somethingWrong = 'Something went wrong';
}
