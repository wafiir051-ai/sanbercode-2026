import 'package:hive_ce/hive.dart';

import 'package:e_commerce_smk/app/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  List<CartItemModel> getCartItems();
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String cartItemId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String cartBoxName = 'cart_box';

  Box<CartItemModel> get _cartBox => Hive.box<CartItemModel>(cartBoxName);

  @override
  List<CartItemModel> getCartItems() => _cartBox.values.toList();

  @override
  Future<void> saveCartItem(CartItemModel item) => _cartBox.put(item.id, item);

  @override
  Future<void> removeCartItem(String cartItemId) => _cartBox.delete(cartItemId);

  @override
  Future<void> clearCart() async {
    await _cartBox.clear();
  }
}
