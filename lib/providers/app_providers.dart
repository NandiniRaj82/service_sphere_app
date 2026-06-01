// ─────────────────────────────────────────────────────────────────────────────
// Services, Bookings, Notifications & Theme Providers — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/chat_message_model.dart';
import '../services/mock_data_service.dart';
import 'auth_provider.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Theme Provider
// ─────────────────────────────────────────────────────────────────────────────

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setDark()  => state = ThemeMode.dark;
  void setLight() => state = ThemeMode.light;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());

// ─────────────────────────────────────────────────────────────────────────────
// Services Provider
// ─────────────────────────────────────────────────────────────────────────────

class ServicesState {
  final List<ServiceModel> all;
  final List<ServiceModel> filtered;
  final String searchQuery;
  final String selectedCategory;
  final bool isLoading;

  const ServicesState({
    this.all = const [],
    this.filtered = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.isLoading = false,
  });

  ServicesState copyWith({
    List<ServiceModel>? all, List<ServiceModel>? filtered,
    String? searchQuery, String? selectedCategory, bool? isLoading,
  }) => ServicesState(
    all: all ?? this.all,
    filtered: filtered ?? this.filtered,
    searchQuery: searchQuery ?? this.searchQuery,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    isLoading: isLoading ?? this.isLoading,
  );
}

class ServicesNotifier extends Notifier<ServicesState> {
  @override
  ServicesState build() {
    _load();
    return const ServicesState(isLoading: true);
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final all = MockDataService.services;
    state = ServicesState(all: all, filtered: all.where((s) => s.isActive).toList());
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void filterByCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  void _applyFilters() {
    var result = state.all.where((s) => s.isActive).toList();
    if (state.selectedCategory != 'All') {
      result = result.where((s) => s.category == state.selectedCategory).toList();
    }
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      result = result.where((s) =>
        s.title.toLowerCase().contains(q) ||
        s.category.toLowerCase().contains(q) ||
        s.providerName.toLowerCase().contains(q) ||
        s.tags.any((t) => t.toLowerCase().contains(q))
      ).toList();
    }
    state = state.copyWith(filtered: result);
  }

  void addService(ServiceModel service) {
    final updated = [...state.all, service];
    state = state.copyWith(all: updated);
    _applyFilters();
  }

  void updateService(ServiceModel service) {
    final updated = state.all.map((s) => s.id == service.id ? service : s).toList();
    state = state.copyWith(all: updated);
    _applyFilters();
  }

  void deleteService(String serviceId) {
    final updated = state.all.where((s) => s.id != serviceId).toList();
    state = state.copyWith(all: updated);
    _applyFilters();
  }

  List<ServiceModel> getByProvider(String providerId) =>
      state.all.where((s) => s.providerId == providerId).toList();

  List<ServiceModel> getFeatured() =>
      state.all.where((s) => s.isFeatured && s.isActive).toList();
}

final servicesProvider = NotifierProvider<ServicesNotifier, ServicesState>(
  () => ServicesNotifier(),
);

final featuredServicesProvider = Provider<List<ServiceModel>>((ref) {
  return ref.watch(servicesProvider).all
      .where((s) => s.isFeatured && s.isActive)
      .toList();
});

// ─────────────────────────────────────────────────────────────────────────────
// Bookings Provider
// ─────────────────────────────────────────────────────────────────────────────

class BookingsNotifier extends Notifier<List<BookingModel>> {
  @override
  List<BookingModel> build() => MockDataService.bookings;

  void addBooking(BookingModel booking) {
    state = [...state, booking];
  }

  void updateStatus(String bookingId, BookingStatus status) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(status: status, updatedAt: DateTime.now());
      }
      return b;
    }).toList();
  }

  void cancelBooking(String bookingId) {
    updateStatus(bookingId, BookingStatus.cancelled);
  }

  void addReview(String bookingId, double rating, String review) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(userRating: rating, userReview: review);
      }
      return b;
    }).toList();
  }

  List<BookingModel> getForUser(String userId) =>
      state.where((b) => b.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<BookingModel> getForProvider(String providerId) =>
      state.where((b) => b.providerId == providerId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<BookingModel> getPendingForProvider(String providerId) =>
      state.where((b) => b.providerId == providerId && b.status == BookingStatus.pending).toList();
}

final bookingsProvider = NotifierProvider<BookingsNotifier, List<BookingModel>>(
  () => BookingsNotifier(),
);

final userBookingsProvider = Provider<List<BookingModel>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  return ref.watch(bookingsProvider.notifier).getForUser(userId);
});

final providerBookingsProvider = Provider<List<BookingModel>>((ref) {
  final providerId = ref.watch(currentUserProvider)?.id;
  if (providerId == null) return [];
  return ref.watch(bookingsProvider.notifier).getForProvider(providerId);
});

final pendingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final providerId = ref.watch(currentUserProvider)?.id;
  if (providerId == null) return [];
  return ref.watch(bookingsProvider.notifier).getPendingForProvider(providerId);
});

// ─────────────────────────────────────────────────────────────────────────────
// Notifications Provider
// ─────────────────────────────────────────────────────────────────────────────

class NotificationsNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    final userId = ref.watch(currentUserProvider)?.id ?? 'u1';
    return MockDataService.getNotificationsForUser(userId);
  }

  void markRead(String notificationId) {
    state = state.map((n) {
      return n.id == notificationId ? n.copyWith(isRead: true) : n;
    }).toList();
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  () => NotificationsNotifier(),
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

// ─────────────────────────────────────────────────────────────────────────────
// Chat Provider
// ─────────────────────────────────────────────────────────────────────────────

class ChatNotifier extends FamilyNotifier<List<ChatMessage>, String> {
  @override
  List<ChatMessage> build(String chatRoomId) {
    return MockDataService.getChatMessages(chatRoomId);
  }

  void sendMessage(String senderId, String senderName, String text) {
    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatRoomId: arg,
      senderId: senderId,
      senderName: senderName,
      text: text,
      createdAt: DateTime.now(),
    );
    state = [...state, message];
  }
}

final chatProvider = NotifierProviderFamily<ChatNotifier, List<ChatMessage>, String>(
  () => ChatNotifier(),
);
