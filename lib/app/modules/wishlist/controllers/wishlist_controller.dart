import 'package:get/get.dart';

import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController => Get.find<HomeController>();
  CartController get cartController => Get.find<CartController>();

  List<ProductModel> get wishlistItems => homeController.products
      .where((p) => homeController.favoriteIds.contains(p.id))
      .toList();

  int get totalCount => wishlistItems.length;

  void removeFromWishlist(String id) => homeController.toggleFavorite(id);

  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    homeController.favoriteIds.remove(product.id);
  }
}
