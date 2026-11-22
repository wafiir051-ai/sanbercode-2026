import 'package:e_commerce_smk/app/utils/currency.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
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
