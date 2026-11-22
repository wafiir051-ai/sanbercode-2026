import 'package:get/get.dart';

import 'package:e_commerce_smk/app/modules/orders/controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    OrdersController.ensure();
  }
}
