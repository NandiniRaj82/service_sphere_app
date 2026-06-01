// ─────────────────────────────────────────────────────────────────────────────
// Service Model — Service Sphere
// ─────────────────────────────────────────────────────────────────────────────

import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final String title;
  final String description;
  final String category;
  final double price;
  final String priceUnit;       // e.g. 'per hour', 'per visit', 'flat'
  final int durationMinutes;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final bool isFeatured;
  final List<String> tags;
  final DateTime createdAt;

  const ServiceModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.priceUnit = 'per visit',
    required this.durationMinutes,
    required this.imageUrls,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.tags = const [],
    required this.createdAt,
  });

  String get durationLabel {
    if (durationMinutes >= 60) {
      final h = durationMinutes ~/ 60;
      final m = durationMinutes % 60;
      return m == 0 ? '$h hr' : '$h hr $m min';
    }
    return '$durationMinutes min';
  }

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  ServiceModel copyWith({
    String? id, String? providerId, String? providerName, String? providerAvatar,
    String? title, String? description, String? category, double? price,
    String? priceUnit, int? durationMinutes, List<String>? imageUrls,
    double? rating, int? reviewCount, bool? isActive, bool? isFeatured,
    List<String>? tags, DateTime? createdAt,
  }) => ServiceModel(
    id: id ?? this.id,
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    providerAvatar: providerAvatar ?? this.providerAvatar,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    price: price ?? this.price,
    priceUnit: priceUnit ?? this.priceUnit,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    imageUrls: imageUrls ?? this.imageUrls,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    isActive: isActive ?? this.isActive,
    isFeatured: isFeatured ?? this.isFeatured,
    tags: tags ?? this.tags,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'providerId': providerId, 'providerName': providerName,
    'providerAvatar': providerAvatar, 'title': title, 'description': description,
    'category': category, 'price': price, 'priceUnit': priceUnit,
    'durationMinutes': durationMinutes, 'imageUrls': imageUrls,
    'rating': rating, 'reviewCount': reviewCount, 'isActive': isActive,
    'isFeatured': isFeatured, 'tags': tags, 'createdAt': createdAt.toIso8601String(),
  };

  factory ServiceModel.fromMap(Map<String, dynamic> map) => ServiceModel(
    id: map['id'] ?? '',
    providerId: map['providerId'] ?? '',
    providerName: map['providerName'] ?? '',
    providerAvatar: map['providerAvatar'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    category: map['category'] ?? '',
    price: (map['price'] as num?)?.toDouble() ?? 0,
    priceUnit: map['priceUnit'] ?? 'per visit',
    durationMinutes: map['durationMinutes'] ?? 60,
    imageUrls: List<String>.from(map['imageUrls'] ?? []),
    rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    reviewCount: map['reviewCount'] ?? 0,
    isActive: map['isActive'] ?? true,
    isFeatured: map['isFeatured'] ?? false,
    tags: List<String>.from(map['tags'] ?? []),
    createdAt: DateTime.parse(map['createdAt']),
  );

  @override
  List<Object?> get props => [id, title, category, price, providerId];
}
