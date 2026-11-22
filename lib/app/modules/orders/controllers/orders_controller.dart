import 'package:get/get.dart';

class OrderRecord {
  final String id;
  final DateTime createdAt;
  final int itemCount;
  final int total;
  final String courier;
  final String payment;
  final String address;

  const OrderRecord({
    required this.id,
    required this.createdAt,
    required this.itemCount,
    required this.total,
    required this.courier,
    required this.payment,
    required this.address,
  });
}

class OrdersController extends GetxController {
  static OrdersController ensure() => Get.isRegistered<OrdersController>()
      ? Get.find<OrdersController>()
      : Get.put(OrdersController(), permanent: true);

  final orders = <OrderRecord>[].obs;

  void addOrder(OrderRecord order) => orders.insert(0, order);
}
