import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/data/local/cart_local_datasource.dart';
import 'package:e_commerce_smk/app/data/models/cart_item_model.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';

class CartController extends GetxController {
  CartController({this._localDataSource});

  final CartLocalDataSource? _localDataSource;

  CartLocalDataSource? get _ds =>
      _localDataSource ??
      (Get.isRegistered<CartLocalDataSource>()
          ? Get.find<CartLocalDataSource>()
          : null);

  final items = <CartItemModel>[].obs;

  static const double taxRate = 0.11;
  static const int freeShippingThreshold = 2000000;
  static const int flatShippingFee = 25000;

  @override
  void onInit() {
    super.onInit();
    items.assignAll(_ds?.getCartItems() ?? const []);
  }

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  int get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);

  int get tax => (subtotal * taxRate).round();

  int get shippingFee {
    if (subtotal == 0) return 0;
    return subtotal >= freeShippingThreshold ? 0 : flatShippingFee;
  }

  int get totalAmount => subtotal + tax + shippingFee;

  void addItem(ProductModel product, {int quantity = 1, String size = '42'}) {
    addItemAsync(product, quantity: quantity, size: size);
  }

  Future<void> addItemAsync(
    ProductModel product, {
    int quantity = 1,
    String size = '42',
  }) async {
    final index = items.indexWhere(
      (i) => i.product.id == product.id && i.selectedSize == size,
    );
    final CartItemModel saved;
    if (index >= 0) {
      saved = items[index].copyWith(quantity: items[index].quantity + quantity);
      items[index] = saved;
    } else {
      saved = CartItemModel(
        product: product,
        selectedSize: size,
        quantity: quantity,
      );
      items.add(saved);
    }
    await _ds?.saveCartItem(saved);

    Get.snackbar(
      'Ditambahkan',
      '${product.name} (size $size) x$quantity masuk keranjang',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
    );
  }

  void increaseQuantity(String id) {
    final index = items.indexWhere((i) => i.id == id);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    _ds?.saveCartItem(items[index]);
  }

  void decreaseQuantity(String id) {
    final index = items.indexWhere((i) => i.id == id);
    if (index < 0) return;
    if (items[index].quantity <= 1) {
      removeItem(id);
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
      _ds?.saveCartItem(items[index]);
    }
  }

  void removeItem(String id) {
    items.removeWhere((i) => i.id == id);
    _ds?.removeCartItem(id);
  }

  Future<void> clearCartAsync() async {
    items.clear();
    await _ds?.clearCart();
  }
}
