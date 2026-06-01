// ─────────────────────────────────────────────────────────────────────────────
// Chat Message Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

enum MessageType { text, image, system }

class ChatMessage extends Equatable {
  final String id;
  final String chatRoomId;   // e.g. "${userId}_${providerId}"
  final String senderId;
  final String senderName;
  final String text;
  final MessageType type;
  final bool isRead;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.type = MessageType.text,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'chatRoomId': chatRoomId, 'senderId': senderId,
    'senderName': senderName, 'text': text, 'type': type.name,
    'isRead': isRead, 'createdAt': createdAt.toIso8601String(),
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    id: map['id'] ?? '',
    chatRoomId: map['chatRoomId'] ?? '',
    senderId: map['senderId'] ?? '',
    senderName: map['senderName'] ?? '',
    text: map['text'] ?? '',
    type: MessageType.values.firstWhere(
      (t) => t.name == map['type'], orElse: () => MessageType.text,
    ),
    isRead: map['isRead'] ?? false,
    createdAt: DateTime.parse(map['createdAt']),
  );

  @override
  List<Object?> get props => [id, chatRoomId, senderId, createdAt];
}

/// Represents a chat room (conversation) between a user and a provider
class ChatRoom extends Equatable {
  final String id;          // "${userId}_${providerId}"
  final String userId;
  final String userName;
  final String providerId;
  final String providerName;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.userId,
    required this.userName,
    required this.providerId,
    required this.providerName,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, userId, providerId];
}
