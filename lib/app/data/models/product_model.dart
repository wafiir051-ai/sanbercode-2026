import 'package:hive_ce/hive.dart';

import 'package:e_commerce_smk/app/utils/currency.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final int reviewCount;
  @HiveField(6)
  final String imageUrl;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    this.reviewCount = 0,
    required this.imageUrl,
    this.description = '',
    this.isFavorite = false,
  });

  String get formattedPrice => formatRupiah(price);

  ProductModel copyWith({bool? isFavorite}) => ProductModel(
    id: id,
    name: name,
    category: category,
    price: price,
    rating: rating,
    reviewCount: reviewCount,
    imageUrl: imageUrl,
    description: description,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawCategory = (json['category'] ?? 'Lifestyle').toString();
    final rawPrice = (json['price'] as num?)?.toInt() ?? 150000;

    return ProductModel(
      id: (json['id'] ?? 'prod-${DateTime.now().millisecondsSinceEpoch}')
          .toString(),
      name: (json['title'] ?? json['name'] ?? 'Sepatu Sneakers').toString(),
      category: rawCategory.isEmpty
          ? 'General'
          : '${rawCategory[0].toUpperCase()}${rawCategory.substring(1)}',
      price: rawPrice < 1000 ? rawPrice * 15000 : rawPrice,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['reviews'] as List?)?.length ?? 0,
      imageUrl:
          (json['thumbnail'] ??
                  json['imageUrl'] ??
                  'https://images.unsplash.com/photo-1542291026-7eec264c27ff')
              .toString(),
      description:
          (json['description'] ?? 'Sepatu sneakers berkualitas tinggi.')
              .toString(),
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'] as String,
    name: map['name'] as String,
    category: map['category'] as String,
    price: (map['price'] as num).toInt(),
    rating: (map['rating'] as num).toDouble(),
    reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
    imageUrl: map['imageUrl'] as String,
    description: (map['description'] ?? '') as String,
  );
}
