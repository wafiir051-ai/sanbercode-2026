import 'package:e_commerce_smk/app/data/local/cart_local_datasource.dart';
import 'package:e_commerce_smk/app/data/models/cart_item_model.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _MemoryCartStore implements CartLocalDataSource {
  final Map<String, CartItemModel> data = {};

  @override
  List<CartItemModel> getCartItems() => data.values.toList();

  @override
  Future<void> saveCartItem(CartItemModel item) async => data[item.id] = item;

  @override
  Future<void> removeCartItem(String cartItemId) async =>
      data.remove(cartItemId);

  @override
  Future<void> clearCart() async => data.clear();
}

const _shoe = ProductModel(
  id: 'shoe-01',
  name: 'Shoe',
  category: 'Running',
  price: 1000000,
  rating: 4.5,
  imageUrl: 'x',
);

void main() {
  test(
    'keranjang dipulihkan dari penyimpanan dan setiap perubahan tersimpan',
    () async {
      final store = _MemoryCartStore();
      await store.saveCartItem(
        CartItemModel(product: _shoe, selectedSize: '42', quantity: 2),
      );

      final cart = CartController(localDataSource: store)..onInit();
      expect(cart.totalItemCount, 2);

      cart.increaseQuantity('shoe-01_42');
      expect(store.data['shoe-01_42']!.quantity, 3);

      cart.decreaseQuantity('shoe-01_42');
      cart.decreaseQuantity('shoe-01_42');
      expect(store.data['shoe-01_42']!.quantity, 1);

      cart.removeItem('shoe-01_42');
      expect(store.data, isEmpty);

      await store.saveCartItem(
        CartItemModel(product: _shoe, selectedSize: '40'),
      );
      cart.items.assignAll(store.getCartItems());
      await cart.clearCartAsync();
      expect(store.data, isEmpty);
      expect(cart.items, isEmpty);
    },
  );
}
