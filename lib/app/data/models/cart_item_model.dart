import 'package:hive_ce/hive.dart';

import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/utils/currency.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  final String selectedSize;

  @HiveField(3)
  int quantity;

  CartItemModel({
    String? id,
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  }) : id = id ?? '${product.id}_$selectedSize';

  int get subtotal => product.price * quantity;
  String get formattedSubtotal => formatRupiah(subtotal);

  CartItemModel copyWith({int? quantity}) => CartItemModel(
    id: id,
    product: product,
    selectedSize: selectedSize,
    quantity: quantity ?? this.quantity,
  );
}
