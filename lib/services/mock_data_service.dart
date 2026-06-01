// ─────────────────────────────────────────────────────────────────────────────
// Mock Data Service — Service Sphere
// Provides rich seed data for all collections (no Firebase required)
// ─────────────────────────────────────────────────────────────────────────────

import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/review_model.dart';
import '../models/notification_model.dart';
import '../models/chat_message_model.dart';

class MockDataService {
  MockDataService._();

  // ── Users ──────────────────────────────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(
      id: 'u1', name: 'Arjun Sharma', email: 'arjun@example.com', phone: '+91 98765 43210',
      role: UserRole.user, isActive: true,
      createdAt: DateTime(2024, 1, 10), address: '14 MG Road, Bangalore',
    ),
    UserModel(
      id: 'u2', name: 'Priya Mehta', email: 'priya@example.com', phone: '+91 87654 32109',
      role: UserRole.user, isActive: true,
      createdAt: DateTime(2024, 2, 5), address: '22 Koramangala, Bangalore',
    ),
    UserModel(
      id: 'u3', name: 'Rahul Kumar', email: 'rahul@example.com', phone: '+91 76543 21098',
      role: UserRole.user, isActive: true,
      createdAt: DateTime(2024, 3, 20), address: '8 Indiranagar, Bangalore',
    ),
    UserModel(
      id: 'u4', name: 'Sneha Patel', email: 'sneha@example.com', phone: '+91 65432 10987',
      role: UserRole.user, isActive: true,
      createdAt: DateTime(2024, 4, 15), address: '33 HSR Layout, Bangalore',
    ),
    UserModel(
      id: 'u5', name: 'Vikram Singh', email: 'vikram@example.com', phone: '+91 54321 09876',
      role: UserRole.user, isBlocked: true,
      createdAt: DateTime(2024, 5, 8), address: '5 Whitefield, Bangalore',
    ),
  ];

  // ── Providers ──────────────────────────────────────────────────────────────
  static final List<UserModel> providers = [
    UserModel(
      id: 'p1', name: 'Ravi Electricals', email: 'ravi@provider.com', phone: '+91 91234 56789',
      role: UserRole.provider, isActive: true,
      createdAt: DateTime(2023, 11, 1), address: 'Marathahalli, Bangalore',
    ),
    UserModel(
      id: 'p2', name: 'CleanPro Services', email: 'cleanpro@provider.com', phone: '+91 80123 45678',
      role: UserRole.provider, isActive: true,
      createdAt: DateTime(2023, 12, 15), address: 'BTM Layout, Bangalore',
    ),
    UserModel(
      id: 'p3', name: 'QuickFix Plumbing', email: 'quickfix@provider.com', phone: '+91 79012 34567',
      role: UserRole.provider, isActive: true,
      createdAt: DateTime(2024, 1, 5), address: 'Jayanagar, Bangalore',
    ),
    UserModel(
      id: 'p4', name: 'AutoCare Hub', email: 'autocare@provider.com', phone: '+91 68901 23456',
      role: UserRole.provider, isActive: false,
      createdAt: DateTime(2024, 2, 20), address: 'Silk Board, Bangalore',
    ),
    UserModel(
      id: 'p5', name: 'GreenThumb Gardening', email: 'greenthumb@provider.com', phone: '+91 57890 12345',
      role: UserRole.provider, isActive: true,
      createdAt: DateTime(2024, 3, 10), address: 'Bellandur, Bangalore',
    ),
  ];

  // ── Admin ──────────────────────────────────────────────────────────────────
  static final UserModel adminUser = UserModel(
    id: 'a1', name: 'Nandini Raj', email: 'admin@servicesphere.com', phone: '+91 99999 00000',
    role: UserRole.admin, isActive: true,
    createdAt: DateTime(2023, 10, 1),
  );

  // ── All accounts for quick login ───────────────────────────────────────────
  static final List<Map<String, dynamic>> demoAccounts = [
    {'email': 'arjun@example.com',      'password': 'user123',  'role': 'user',     'name': 'Arjun Sharma'},
    {'email': 'priya@example.com',      'password': 'user123',  'role': 'user',     'name': 'Priya Mehta'},
    {'email': 'ravi@provider.com',      'password': 'prov123',  'role': 'provider', 'name': 'Ravi Electricals'},
    {'email': 'cleanpro@provider.com',  'password': 'prov123',  'role': 'provider', 'name': 'CleanPro Services'},
    {'email': 'admin@servicesphere.com','password': 'admin123', 'role': 'admin',    'name': 'Nandini Raj'},
  ];

  // ── Services ───────────────────────────────────────────────────────────────
  static final List<ServiceModel> services = [
    ServiceModel(
      id: 's1', providerId: 'p1', providerName: 'Ravi Electricals', providerAvatar: '',
      title: 'Home Electrical Repair', description: 'Expert electrical fault diagnosis and repair for your home. Covers wiring, switches, sockets, MCBs, and short-circuit fixes. All work done with ISI certified materials.',
      category: 'Electrical', price: 499, priceUnit: 'per visit',
      durationMinutes: 60, imageUrls: [], rating: 4.8, reviewCount: 124,
      isActive: true, isFeatured: true, tags: ['wiring', 'repair', 'MCB', 'switches'],
      createdAt: DateTime(2024, 1, 10),
    ),
    ServiceModel(
      id: 's2', providerId: 'p1', providerName: 'Ravi Electricals', providerAvatar: '',
      title: 'AC Installation & Service', description: 'Professional split/window AC installation, gas refilling, and annual maintenance contract. Fully licensed technicians with 1-year workmanship warranty.',
      category: 'Appliance Repair', price: 799, priceUnit: 'per visit',
      durationMinutes: 90, imageUrls: [], rating: 4.6, reviewCount: 87,
      isActive: true, isFeatured: true, tags: ['AC', 'installation', 'service', 'cooling'],
      createdAt: DateTime(2024, 1, 15),
    ),
    ServiceModel(
      id: 's3', providerId: 'p2', providerName: 'CleanPro Services', providerAvatar: '',
      title: 'Deep Home Cleaning', description: 'Comprehensive top-to-bottom home cleaning including kitchen degreasing, bathroom sanitization, floor mopping, and window cleaning. Eco-friendly products used.',
      category: 'Cleaning', price: 1299, priceUnit: 'flat',
      durationMinutes: 180, imageUrls: [], rating: 4.9, reviewCount: 212,
      isActive: true, isFeatured: true, tags: ['cleaning', 'home', 'deep clean', 'sanitize'],
      createdAt: DateTime(2024, 1, 20),
    ),
    ServiceModel(
      id: 's4', providerId: 'p2', providerName: 'CleanPro Services', providerAvatar: '',
      title: 'Sofa & Upholstery Cleaning', description: 'Professional cleaning of sofas, chairs, mattresses, and carpets using steam and dry-cleaning methods. Removes stains, dust, and allergens effectively.',
      category: 'Cleaning', price: 699, priceUnit: 'per item',
      durationMinutes: 60, imageUrls: [], rating: 4.7, reviewCount: 95,
      isActive: true, isFeatured: false, tags: ['sofa', 'cleaning', 'upholstery', 'steam'],
      createdAt: DateTime(2024, 2, 1),
    ),
    ServiceModel(
      id: 's5', providerId: 'p3', providerName: 'QuickFix Plumbing', providerAvatar: '',
      title: 'Pipe Leak Repair', description: 'Emergency and scheduled pipe leak detection and repair service. Covers all pipe materials — PVC, CPVC, GI, copper. Same-day service available.',
      category: 'Plumbing', price: 399, priceUnit: 'per visit',
      durationMinutes: 45, imageUrls: [], rating: 4.5, reviewCount: 156,
      isActive: true, isFeatured: false, tags: ['pipe', 'leak', 'plumbing', 'emergency'],
      createdAt: DateTime(2024, 2, 10),
    ),
    ServiceModel(
      id: 's6', providerId: 'p3', providerName: 'QuickFix Plumbing', providerAvatar: '',
      title: 'Bathroom Fixture Installation', description: 'Installation of geysers, showers, taps, commodes, wash basins, and other bathroom fixtures. We source quality fittings at market prices.',
      category: 'Plumbing', price: 599, priceUnit: 'per fixture',
      durationMinutes: 60, imageUrls: [], rating: 4.4, reviewCount: 73,
      isActive: true, isFeatured: false, tags: ['bathroom', 'geyser', 'shower', 'installation'],
      createdAt: DateTime(2024, 2, 15),
    ),
    ServiceModel(
      id: 's7', providerId: 'p4', providerName: 'AutoCare Hub', providerAvatar: '',
      title: 'Car Wash & Detailing', description: 'Premium car wash, interior vacuuming, seat cleaning, dashboard polish, and exterior wax coating. All vehicles welcome — sedans, SUVs, MPVs.',
      category: 'Car Service', price: 899, priceUnit: 'per visit',
      durationMinutes: 120, imageUrls: [], rating: 4.3, reviewCount: 48,
      isActive: false, isFeatured: false, tags: ['car', 'wash', 'detailing', 'polish'],
      createdAt: DateTime(2024, 3, 1),
    ),
    ServiceModel(
      id: 's8', providerId: 'p5', providerName: 'GreenThumb Gardening', providerAvatar: '',
      title: 'Garden Maintenance', description: 'Monthly and one-time garden maintenance including mowing, trimming, weeding, fertilizing, and seasonal planting. Transform your outdoor space beautifully.',
      category: 'Gardening', price: 799, priceUnit: 'per visit',
      durationMinutes: 120, imageUrls: [], rating: 4.7, reviewCount: 61,
      isActive: true, isFeatured: true, tags: ['garden', 'landscaping', 'mowing', 'plants'],
      createdAt: DateTime(2024, 3, 10),
    ),
    ServiceModel(
      id: 's9', providerId: 'p1', providerName: 'Ravi Electricals', providerAvatar: '',
      title: 'Solar Panel Installation', description: 'Complete rooftop solar system design, procurement, and installation. Grid-tied and off-grid solutions. Free consultation and site survey included.',
      category: 'Solar', price: 45000, priceUnit: 'per kW',
      durationMinutes: 480, imageUrls: [], rating: 4.9, reviewCount: 29,
      isActive: true, isFeatured: true, tags: ['solar', 'renewable', 'installation', 'rooftop'],
      createdAt: DateTime(2024, 3, 20),
    ),
    ServiceModel(
      id: 's10', providerId: 'p2', providerName: 'CleanPro Services', providerAvatar: '',
      title: 'Office Deep Cleaning', description: 'Professional office cleaning service covering workstations, conference rooms, pantry, washrooms, and common areas. Flexible timings to avoid business disruption.',
      category: 'Cleaning', price: 2499, priceUnit: 'per session',
      durationMinutes: 240, imageUrls: [], rating: 4.8, reviewCount: 44,
      isActive: true, isFeatured: false, tags: ['office', 'commercial', 'cleaning', 'corporate'],
      createdAt: DateTime(2024, 4, 1),
    ),
    ServiceModel(
      id: 's11', providerId: 'p3', providerName: 'QuickFix Plumbing', providerAvatar: '',
      title: 'Water Tank Cleaning', description: 'Complete overhead and underground tank cleaning with high-pressure jet washing. Sanitization with food-grade chemicals. Removes sludge and bacteria.',
      category: 'Water Supply', price: 1499, priceUnit: 'per tank',
      durationMinutes: 180, imageUrls: [], rating: 4.6, reviewCount: 82,
      isActive: true, isFeatured: false, tags: ['water', 'tank', 'cleaning', 'sanitize'],
      createdAt: DateTime(2024, 4, 10),
    ),
    ServiceModel(
      id: 's12', providerId: 'p5', providerName: 'GreenThumb Gardening', providerAvatar: '',
      title: 'Indoor Plant Care & Styling', description: 'Expert advice and arrangement of indoor plants. Includes repotting, fertilizing, and customized plant styling for homes and offices.',
      category: 'Gardening', price: 599, priceUnit: 'per visit',
      durationMinutes: 60, imageUrls: [], rating: 4.5, reviewCount: 37,
      isActive: true, isFeatured: false, tags: ['indoor', 'plants', 'styling', 'care'],
      createdAt: DateTime(2024, 4, 20),
    ),
  ];

  // ── Bookings ───────────────────────────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'b1', userId: 'u1', userName: 'Arjun Sharma', userPhone: '+91 98765 43210',
      providerId: 'p1', providerName: 'Ravi Electricals',
      serviceId: 's1', serviceTitle: 'Home Electrical Repair',
      serviceCategory: 'Electrical', servicePrice: 499,
      scheduledAt: DateTime.now().add(const Duration(days: 2, hours: 10)),
      durationMinutes: 60, status: BookingStatus.confirmed,
      address: '14 MG Road, Bangalore', isPaid: true,
      notes: 'Living room ceiling fan not working', createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingModel(
      id: 'b2', userId: 'u1', userName: 'Arjun Sharma', userPhone: '+91 98765 43210',
      providerId: 'p2', providerName: 'CleanPro Services',
      serviceId: 's3', serviceTitle: 'Deep Home Cleaning',
      serviceCategory: 'Cleaning', servicePrice: 1299,
      scheduledAt: DateTime.now().subtract(const Duration(days: 10)),
      durationMinutes: 180, status: BookingStatus.completed,
      address: '14 MG Road, Bangalore', isPaid: true,
      userRating: 4.5, userReview: 'Excellent service! Very thorough cleaning.',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    BookingModel(
      id: 'b3', userId: 'u2', userName: 'Priya Mehta', userPhone: '+91 87654 32109',
      providerId: 'p3', providerName: 'QuickFix Plumbing',
      serviceId: 's5', serviceTitle: 'Pipe Leak Repair',
      serviceCategory: 'Plumbing', servicePrice: 399,
      scheduledAt: DateTime.now().add(const Duration(hours: 5)),
      durationMinutes: 45, status: BookingStatus.pending,
      address: '22 Koramangala, Bangalore', isPaid: false,
      notes: 'Kitchen sink pipe leaking since morning',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BookingModel(
      id: 'b4', userId: 'u2', userName: 'Priya Mehta', userPhone: '+91 87654 32109',
      providerId: 'p1', providerName: 'Ravi Electricals',
      serviceId: 's2', serviceTitle: 'AC Installation & Service',
      serviceCategory: 'Appliance Repair', servicePrice: 799,
      scheduledAt: DateTime.now().subtract(const Duration(days: 5)),
      durationMinutes: 90, status: BookingStatus.rejected,
      address: '22 Koramangala, Bangalore', isPaid: false,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    BookingModel(
      id: 'b5', userId: 'u3', userName: 'Rahul Kumar', userPhone: '+91 76543 21098',
      providerId: 'p5', providerName: 'GreenThumb Gardening',
      serviceId: 's8', serviceTitle: 'Garden Maintenance',
      serviceCategory: 'Gardening', servicePrice: 799,
      scheduledAt: DateTime.now().add(const Duration(days: 7)),
      durationMinutes: 120, status: BookingStatus.confirmed,
      address: '8 Indiranagar, Bangalore', isPaid: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    BookingModel(
      id: 'b6', userId: 'u4', userName: 'Sneha Patel', userPhone: '+91 65432 10987',
      providerId: 'p2', providerName: 'CleanPro Services',
      serviceId: 's10', serviceTitle: 'Office Deep Cleaning',
      serviceCategory: 'Cleaning', servicePrice: 2499,
      scheduledAt: DateTime.now().subtract(const Duration(days: 20)),
      durationMinutes: 240, status: BookingStatus.completed,
      address: '33 HSR Layout, Bangalore', isPaid: true,
      userRating: 5.0, userReview: 'Outstanding work, office looks brand new!',
      createdAt: DateTime.now().subtract(const Duration(days: 22)),
    ),
    BookingModel(
      id: 'b7', userId: 'u1', userName: 'Arjun Sharma', userPhone: '+91 98765 43210',
      providerId: 'p3', providerName: 'QuickFix Plumbing',
      serviceId: 's11', serviceTitle: 'Water Tank Cleaning',
      serviceCategory: 'Water Supply', servicePrice: 1499,
      scheduledAt: DateTime.now().add(const Duration(days: 4)),
      durationMinutes: 180, status: BookingStatus.pending,
      address: '14 MG Road, Bangalore', isPaid: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    BookingModel(
      id: 'b8', userId: 'u3', userName: 'Rahul Kumar', userPhone: '+91 76543 21098',
      providerId: 'p1', providerName: 'Ravi Electricals',
      serviceId: 's9', serviceTitle: 'Solar Panel Installation',
      serviceCategory: 'Solar', servicePrice: 45000,
      scheduledAt: DateTime.now().subtract(const Duration(days: 2)),
      durationMinutes: 480, status: BookingStatus.cancelled,
      address: '8 Indiranagar, Bangalore', isPaid: false,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  // ── Reviews ────────────────────────────────────────────────────────────────
  static final List<ReviewModel> reviews = [
    ReviewModel(
      id: 'r1', userId: 'u1', userName: 'Arjun Sharma',
      serviceId: 's3', bookingId: 'b2', rating: 4.5,
      comment: 'Excellent service! Very thorough cleaning. Team was professional and on time.',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    ReviewModel(
      id: 'r2', userId: 'u4', userName: 'Sneha Patel',
      serviceId: 's10', bookingId: 'b6', rating: 5.0,
      comment: 'Outstanding work! The office looks brand new. Highly recommended.',
      createdAt: DateTime.now().subtract(const Duration(days: 19)),
    ),
    ReviewModel(
      id: 'r3', userId: 'u2', userName: 'Priya Mehta',
      serviceId: 's1', bookingId: 'b3', rating: 4.0,
      comment: 'Good work, fixed the electrical issue quickly. Slightly expensive.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewModel(
      id: 'r4', userId: 'u3', userName: 'Rahul Kumar',
      serviceId: 's8', bookingId: 'b5', rating: 5.0,
      comment: 'Amazing transformation of my garden! Really know their plants.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────
  static List<NotificationModel> getNotificationsForUser(String userId) => [
    NotificationModel(
      id: 'n1', userId: userId,
      title: 'Booking Confirmed! 🎉',
      body: 'Your booking for Home Electrical Repair has been confirmed for tomorrow at 10:00 AM.',
      type: NotificationType.bookingUpdate, isRead: false, actionId: 'b1',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 'n2', userId: userId,
      title: 'Payment Successful ✅',
      body: 'Payment of ₹499 received for booking #B001. Thank you!',
      type: NotificationType.payment, isRead: false, actionId: 'b1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n3', userId: userId,
      title: 'New Message from Ravi Electricals 💬',
      body: 'Hi! I will arrive at 10 AM sharp. Please keep the area clear.',
      type: NotificationType.chat, isRead: true, actionId: 'p1',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'n4', userId: userId,
      title: 'Special Offer! 🎁',
      body: 'Get 20% off on your next Deep Cleaning booking. Use code CLEAN20.',
      type: NotificationType.promotion, isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'n5', userId: userId,
      title: 'Booking Completed 🏆',
      body: 'Your Deep Home Cleaning service is completed. Rate your experience!',
      type: NotificationType.bookingUpdate, isRead: true, actionId: 'b2',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // ── Chat Messages ──────────────────────────────────────────────────────────
  static List<ChatMessage> getChatMessages(String chatRoomId) => [
    ChatMessage(
      id: 'msg1', chatRoomId: chatRoomId, senderId: 'u1', senderName: 'Arjun Sharma',
      text: 'Hello! I have a booking for tomorrow. Is 10 AM fine?',
      createdAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
    ),
    ChatMessage(
      id: 'msg2', chatRoomId: chatRoomId, senderId: 'p1', senderName: 'Ravi Electricals',
      text: 'Hi Arjun! Yes, 10 AM works perfectly. Please keep the main switchboard accessible.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ChatMessage(
      id: 'msg3', chatRoomId: chatRoomId, senderId: 'u1', senderName: 'Arjun Sharma',
      text: 'Sure! The issue is with the ceiling fan in the living room. It stopped working suddenly.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
    ),
    ChatMessage(
      id: 'msg4', chatRoomId: chatRoomId, senderId: 'p1', senderName: 'Ravi Electricals',
      text: 'Understood. Could be a capacitor issue or regulator fault. I will bring spares. No worries!',
      createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
    ),
    ChatMessage(
      id: 'msg5', chatRoomId: chatRoomId, senderId: 'u1', senderName: 'Arjun Sharma',
      text: 'Great, thank you! See you tomorrow 👍',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ChatMessage(
      id: 'msg6', chatRoomId: chatRoomId, senderId: 'p1', senderName: 'Ravi Electricals',
      text: 'See you tomorrow! I will arrive at 10 AM sharp 🔧',
      createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 55)),
    ),
  ];

  // ── Analytics Data ──────────────────────────────────────────────────────────
  static final Map<String, dynamic> adminAnalytics = {
    'totalUsers':     users.length,
    'totalProviders': providers.length,
    'totalServices':  services.length,
    'totalBookings':  bookings.length,
    'activeBookings': bookings.where((b) => b.status.isActive).length,
    'completedBookings': bookings.where((b) => b.status == BookingStatus.completed).length,
    'totalRevenue':   bookings
        .where((b) => b.isPaid)
        .fold<double>(0, (sum, b) => sum + b.servicePrice),
    'monthlyRevenue': [18500.0, 22300.0, 19800.0, 31200.0, 28700.0, 35400.0],
    'monthlyBookings': [12, 18, 15, 24, 21, 28],
    'categoryDistribution': {
      'Electrical': 3, 'Cleaning': 4, 'Plumbing': 3, 'Gardening': 2,
      'Car Service': 1, 'Solar': 1, 'Appliance Repair': 1, 'Water Supply': 1,
    },
  };

  /// Revenue data for provider dashboard
  static Map<String, dynamic> getProviderAnalytics(String providerId) {
    final providerBookings = bookings.where((b) => b.providerId == providerId).toList();
    return {
      'totalBookings':     providerBookings.length,
      'completedBookings': providerBookings.where((b) => b.status == BookingStatus.completed).length,
      'pendingBookings':   providerBookings.where((b) => b.status == BookingStatus.pending).length,
      'revenue':           providerBookings.where((b) => b.isPaid).fold<double>(0, (s, b) => s + b.servicePrice),
      'weeklyRevenue':     [850.0, 1200.0, 700.0, 1800.0, 1100.0, 2100.0, 900.0],
    };
  }

  // ── Activity Logs ──────────────────────────────────────────────────────────
  static final List<Map<String, dynamic>> activityLogs = [
    {'id': 'log1', 'action': 'New user registered: Sneha Patel',   'user': 'Sneha Patel',           'type': 'user',    'time': DateTime.now().subtract(const Duration(minutes: 5))},
    {'id': 'log2', 'action': 'Booking #B007 created',              'user': 'Arjun Sharma',          'type': 'booking', 'time': DateTime.now().subtract(const Duration(hours: 1))},
    {'id': 'log3', 'action': 'Provider CleanPro approved',         'user': 'Admin',                 'type': 'admin',   'time': DateTime.now().subtract(const Duration(hours: 2))},
    {'id': 'log4', 'action': 'Service s7 deactivated',             'user': 'Admin',                 'type': 'service', 'time': DateTime.now().subtract(const Duration(hours: 4))},
    {'id': 'log5', 'action': 'User Vikram Singh blocked',          'user': 'Admin',                 'type': 'user',    'time': DateTime.now().subtract(const Duration(hours: 6))},
    {'id': 'log6', 'action': 'Booking #B006 marked completed',     'user': 'CleanPro Services',     'type': 'booking', 'time': DateTime.now().subtract(const Duration(days: 1))},
    {'id': 'log7', 'action': 'Payment received ₹2499',             'user': 'System',                'type': 'payment', 'time': DateTime.now().subtract(const Duration(days: 1, hours: 1))},
    {'id': 'log8', 'action': 'New service added: Indoor Plant Care','user': 'GreenThumb Gardening', 'type': 'service', 'time': DateTime.now().subtract(const Duration(days: 2))},
    {'id': 'log9', 'action': 'Booking #B003 payment processed',    'user': 'Priya Mehta',           'type': 'payment', 'time': DateTime.now().subtract(const Duration(days: 2, hours: 3))},
    {'id': 'log10','action': 'Admin login from new device',        'user': 'Nandini Raj',           'type': 'admin',   'time': DateTime.now().subtract(const Duration(days: 3))},
  ];

  // ── Category Distribution ──────────────────────────────────────────────────
  static Map<String, int> get categoryDistribution => {
    'Electrical': 3, 'Cleaning': 4, 'Plumbing': 3,
    'Gardening': 2, 'Car Service': 1, 'Solar': 1,
  };

  // ── AI Recommendations ─────────────────────────────────────────────────────
  /// Returns recommended services based on booking history (mock algorithm)
  static List<ServiceModel> getRecommendations(String userId) {
    // Simulate category-based recommendations
    final userBookings = bookings.where((b) => b.userId == userId).toList();
    final bookedCategories = userBookings.map((b) => b.serviceCategory).toSet();

    // Recommend services from same and adjacent categories
    return services.where((s) {
      if (!s.isActive) return false;
      if (bookedCategories.contains(s.category)) return true;
      return s.isFeatured; // Also include featured services
    }).take(4).toList();
  }

  /// Time slots for booking
  static List<String> getAvailableTimeSlots(DateTime date) => [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM',
    '05:00 PM', '06:00 PM',
  ];
}
