// ─────────────────────────────────────────────────────────────────────────────
// Booking Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, rejected, completed, cancelled }

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:   return 'Pending';
      case BookingStatus.confirmed: return 'Confirmed';
      case BookingStatus.rejected:  return 'Rejected';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }

  bool get isActive => this == BookingStatus.pending || this == BookingStatus.confirmed;
}

class BookingModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String providerId;
  final String providerName;
  final String serviceId;
  final String serviceTitle;
  final String serviceCategory;
  final double servicePrice;
  final DateTime scheduledAt;
  final int durationMinutes;
  final BookingStatus status;
  final String? notes;
  final String? address;
  final String? paymentId;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? userRating;
  final String? userReview;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.providerId,
    required this.providerName,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceCategory,
    required this.servicePrice,
    required this.scheduledAt,
    required this.durationMinutes,
    this.status = BookingStatus.pending,
    this.notes,
    this.address,
    this.paymentId,
    this.isPaid = false,
    required this.createdAt,
    this.updatedAt,
    this.userRating,
    this.userReview,
  });

  DateTime get scheduledEnd => scheduledAt.add(Duration(minutes: durationMinutes));

  BookingModel copyWith({
    String? id, String? userId, String? userName, String? userPhone,
    String? providerId, String? providerName, String? serviceId,
    String? serviceTitle, String? serviceCategory, double? servicePrice,
    DateTime? scheduledAt, int? durationMinutes, BookingStatus? status,
    String? notes, String? address, String? paymentId, bool? isPaid,
    DateTime? createdAt, DateTime? updatedAt, double? userRating, String? userReview,
  }) => BookingModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userPhone: userPhone ?? this.userPhone,
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    serviceId: serviceId ?? this.serviceId,
    serviceTitle: serviceTitle ?? this.serviceTitle,
    serviceCategory: serviceCategory ?? this.serviceCategory,
    servicePrice: servicePrice ?? this.servicePrice,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    address: address ?? this.address,
    paymentId: paymentId ?? this.paymentId,
    isPaid: isPaid ?? this.isPaid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    userRating: userRating ?? this.userRating,
    userReview: userReview ?? this.userReview,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'userId': userId, 'userName': userName, 'userPhone': userPhone,
    'providerId': providerId, 'providerName': providerName,
    'serviceId': serviceId, 'serviceTitle': serviceTitle,
    'serviceCategory': serviceCategory, 'servicePrice': servicePrice,
    'scheduledAt': scheduledAt.toIso8601String(), 'durationMinutes': durationMinutes,
    'status': status.name, 'notes': notes, 'address': address,
    'paymentId': paymentId, 'isPaid': isPaid,
    'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt?.toIso8601String(),
    'userRating': userRating, 'userReview': userReview,
  };

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    userName: map['userName'] ?? '',
    userPhone: map['userPhone'] ?? '',
    providerId: map['providerId'] ?? '',
    providerName: map['providerName'] ?? '',
    serviceId: map['serviceId'] ?? '',
    serviceTitle: map['serviceTitle'] ?? '',
    serviceCategory: map['serviceCategory'] ?? '',
    servicePrice: (map['servicePrice'] as num?)?.toDouble() ?? 0,
    scheduledAt: DateTime.parse(map['scheduledAt']),
    durationMinutes: map['durationMinutes'] ?? 60,
    status: BookingStatus.values.firstWhere(
      (s) => s.name == map['status'], orElse: () => BookingStatus.pending,
    ),
    notes: map['notes'],
    address: map['address'],
    paymentId: map['paymentId'],
    isPaid: map['isPaid'] ?? false,
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    userRating: (map['userRating'] as num?)?.toDouble(),
    userReview: map['userReview'],
  );

  @override
  List<Object?> get props => [id, userId, providerId, serviceId, status, scheduledAt];
}
