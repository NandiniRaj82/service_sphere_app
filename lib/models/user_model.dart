// ─────────────────────────────────────────────────────────────────────────────
// User Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

enum UserRole { user, provider, admin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:    return 'Admin';
      case UserRole.provider: return 'Provider';
      case UserRole.user:     return 'Customer';
    }
  }
}


class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final UserRole role;
  final bool isActive;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? address;
  final double? latitude;
  final double? longitude;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.role,
    this.isActive = true,
    this.isBlocked = false,
    required this.createdAt,
    this.updatedAt,
    this.address,
    this.latitude,
    this.longitude,
  });

  /// Role-based display label
  String get roleLabel {
    switch (role) {
      case UserRole.admin:    return 'Admin';
      case UserRole.provider: return 'Provider';
      case UserRole.user:     return 'User';
    }
  }

  /// Initials for avatar fallback
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    bool? isActive,
    bool? isBlocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'email': email, 'phone': phone,
    'avatarUrl': avatarUrl, 'role': role.name, 'isActive': isActive,
    'isBlocked': isBlocked, 'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(), 'address': address,
    'latitude': latitude, 'longitude': longitude,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    phone: map['phone'] ?? '',
    avatarUrl: map['avatarUrl'],
    role: UserRole.values.firstWhere((r) => r.name == map['role'], orElse: () => UserRole.user),
    isActive: map['isActive'] ?? true,
    isBlocked: map['isBlocked'] ?? false,
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    address: map['address'],
    latitude: map['latitude']?.toDouble(),
    longitude: map['longitude']?.toDouble(),
  );

  @override
  List<Object?> get props => [id, name, email, phone, role, isActive, isBlocked];
}
