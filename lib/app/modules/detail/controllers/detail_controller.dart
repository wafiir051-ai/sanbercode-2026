import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  late final Map<String, dynamic> product;

  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final sizes = const ['39', '40', '41', '42', '43', '44'];

  HomeController get homeController {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    }
    return Get.put(HomeController());
  }

  @override
  void onInit() {
    super.onInit();
    product = Map<String, dynamic>.from(Get.arguments as Map);
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectSize(String size) => selectedSize.value = size;

  bool get isFavorite => homeController.isFavorite(product['id']);

  void toggleFavorite() => homeController.toggleFavorite(product['id']);

  void addToCart() {
    homeController.addToCart(product, quantity: quantity.value);
    quantity.value = 1;
  }
}
