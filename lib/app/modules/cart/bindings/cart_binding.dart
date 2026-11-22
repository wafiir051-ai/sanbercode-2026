import 'package:get/get.dart';

import 'package:e_commerce_smk/app/data/local/cart_local_datasource.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartLocalDataSource>()) {
      Get.lazyPut<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(),
        fenix: true,
      );
    }
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
  }
}
