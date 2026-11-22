import 'package:get/get.dart';

import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
