import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final product = Rx<ProductModel?>(null);

  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final sizes = const ['39', '40', '41', '42', '43', '44'];

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  HomeController get homeController {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    }
    return Get.put(HomeController());
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
    } else if (args is Map) {
      product.value = ProductModel.fromMap(Map<String, dynamic>.from(args));
    }
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectSize(String size) => selectedSize.value = size;

  bool get isFavorite =>
      product.value != null && homeController.isFavorite(product.value!.id);

  void toggleFavorite() {
    if (product.value == null) return;
    homeController.toggleFavorite(product.value!.id);
  }

  void addToCart() {
    if (product.value == null) return;
    cartController.addItem(
      product.value!,
      quantity: quantity.value,
      size: selectedSize.value,
    );
    quantity.value = 1;
  }
}
