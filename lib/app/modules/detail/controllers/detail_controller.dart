import 'package:get/get.dart';

import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final product = Rx<ProductModel?>(null);
  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final isFavorite = false.obs;

  final availableSizes = ['40', '41', '42', '43', '44'];

  CartController get cartController => Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
      if (Get.isRegistered<HomeController>()) {
        isFavorite.value = Get.find<HomeController>().isFavorite(args.id);
      }
    }
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void changeSize(String size) => selectedSize.value = size;

  void toggleFavorite() {
    final p = product.value;
    if (p == null) return;
    isFavorite.value = !isFavorite.value;
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().toggleFavorite(p.id);
    }
  }

  void addToCart() {
    final p = product.value;
    if (p == null) return;
    cartController.addItem(
      p,
      quantity: quantity.value,
      size: selectedSize.value,
    );
    quantity.value = 1;
  }
}
