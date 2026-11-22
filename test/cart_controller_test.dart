import 'package:e_commerce_smk/app/data/models/cart_item_model.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_test/flutter_test.dart';

ProductModel _shoe(int price) => ProductModel(
  id: 'p$price',
  name: 'Shoe',
  category: 'Running',
  price: price,
  rating: 4.5,
  imageUrl: 'x',
);

void main() {
  test('subtotal, PPN 11%, dan ongkir mengikuti ambang gratis ongkir', () {
    final cart = CartController();
    cart.items.add(
      CartItemModel(product: _shoe(1000000), selectedSize: '42', quantity: 2),
    );
    expect(cart.subtotal, 2000000);
    expect(cart.tax, 220000);
    expect(cart.shippingFee, 0);
    expect(cart.totalAmount, 2220000);

    cart.decreaseQuantity('p1000000_42');
    expect(cart.shippingFee, 25000);
    expect(cart.totalItemCount, 1);

    cart.decreaseQuantity('p1000000_42');
    expect(cart.items, isEmpty);
    expect(cart.shippingFee, 0);
  });
}
