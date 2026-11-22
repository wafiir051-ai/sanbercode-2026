import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/network/dio_client.dart';
import 'package:e_commerce_smk/app/data/remote/product_remote_datasource.dart';
import 'package:e_commerce_smk/app/data/repository/product_repository.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductRepository>()),
      fenix: true,
    );
  }
}
