import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    }
    return Get.put(HomeController());
  }

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  List<ProductModel> get wishlistItems => homeController.products
      .where((p) => homeController.favoriteIds.contains(p.id))
      .toList();

  void removeFromWishlist(String id) => homeController.toggleFavorite(id);

  void moveToCart(ProductModel product) {
    cartController.addItem(product);
    homeController.favoriteIds.remove(product.id);
  }
}
