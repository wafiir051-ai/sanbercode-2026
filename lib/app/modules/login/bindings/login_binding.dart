import 'package:get/get.dart';

import 'package:e_commerce_smk/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
