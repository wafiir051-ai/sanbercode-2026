import 'package:get/get.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final items = <CartItemModel>[].obs;

  static const double taxRate = 0.11;
  static const int freeShippingThreshold = 2000000;
  static const int flatShippingFee = 25000;

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  int get subtotal => items.fold(0, (sum, i) => sum + i.subtotal);

  int get tax => (subtotal * taxRate).round();

  int get shippingFee {
    if (subtotal == 0) return 0;
    return subtotal >= freeShippingThreshold ? 0 : flatShippingFee;
  }

  int get totalAmount => subtotal + tax + shippingFee;

  void addItem(ProductModel product, {int quantity = 1, String size = '42'}) {
    final index =
        items.indexWhere((i) => i.product.id == product.id && i.selectedSize == size);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + quantity);
    } else {
      items.add(CartItemModel(
        product: product,
        selectedSize: size,
        quantity: quantity,
      ));
    }
    Get.snackbar(
      'Ditambahkan',
      '${product.name} (size $size) x$quantity masuk keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void increaseQuantity(String id) {
    final index = items.indexWhere((i) => i.id == id);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
  }

  void decreaseQuantity(String id) {
    final index = items.indexWhere((i) => i.id == id);
    if (index < 0) return;
    final current = items[index].quantity;
    if (current <= 1) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: current - 1);
    }
  }

  void removeItem(String id) => items.removeWhere((i) => i.id == id);

  void clearCart() => items.clear();

  void checkout() {
    if (items.isEmpty) return;
    final total = totalAmount;
    clearCart();
    Get.snackbar(
      'Checkout berhasil',
      'Terima kasih! Total pembayaran: Rp $total',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
