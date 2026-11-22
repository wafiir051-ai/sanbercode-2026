import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/network/dio_client.dart';
import 'package:e_commerce_smk/app/data/local/product_local_datasource.dart';
import 'package:e_commerce_smk/app/data/remote/product_remote_datasource.dart';
import 'package:e_commerce_smk/app/data/repository/product_repository.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/wishlist/controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    }
    if (!Get.isRegistered<ProductRemoteDataSource>()) {
      Get.lazyPut<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(Get.find<DioClient>()),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ProductLocalDataSource>()) {
      Get.lazyPut<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(),
        fenix: true,
      );
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(
          Get.find<ProductRemoteDataSource>(),
          Get.find<ProductLocalDataSource>(),
        ),
        fenix: true,
      );
    }

    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<WishlistController>(
      () => WishlistController(Get.find<ProductRepository>()),
    );
  }
}
