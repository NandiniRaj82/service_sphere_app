// ─────────────────────────────────────────────────────────────────────────────
// Review Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String serviceId;
  final String bookingId;
  final double rating;       // 1.0 – 5.0
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.serviceId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'userId': userId, 'userName': userName, 'userAvatar': userAvatar,
    'serviceId': serviceId, 'bookingId': bookingId, 'rating': rating,
    'comment': comment, 'createdAt': createdAt.toIso8601String(),
  };

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    userName: map['userName'] ?? '',
    userAvatar: map['userAvatar'],
    serviceId: map['serviceId'] ?? '',
    bookingId: map['bookingId'] ?? '',
    rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
    comment: map['comment'] ?? '',
    createdAt: DateTime.parse(map['createdAt']),
  );

  @override
  List<Object?> get props => [id, userId, serviceId, rating];
}
