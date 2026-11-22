import 'package:get/get.dart';

import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/detail/controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
