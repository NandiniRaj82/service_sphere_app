// ─────────────────────────────────────────────────────────────────────────────
// Notification Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

enum NotificationType { bookingUpdate, payment, system, chat, promotion }

class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? actionId;   // e.g. bookingId to navigate to
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.actionId,
    required this.createdAt,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id, userId: userId, title: title, body: body,
    type: type, isRead: isRead ?? this.isRead,
    actionId: actionId, createdAt: createdAt,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'userId': userId, 'title': title, 'body': body,
    'type': type.name, 'isRead': isRead, 'actionId': actionId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) => NotificationModel(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    title: map['title'] ?? '',
    body: map['body'] ?? '',
    type: NotificationType.values.firstWhere(
      (t) => t.name == map['type'], orElse: () => NotificationType.system,
    ),
    isRead: map['isRead'] ?? false,
    actionId: map['actionId'],
    createdAt: DateTime.parse(map['createdAt']),
  );

  @override
  List<Object?> get props => [id, userId, isRead];
}
