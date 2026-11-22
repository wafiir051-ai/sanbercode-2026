import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/data/repository/product_repository.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  WishlistController(this._productRepository);

  final ProductRepository _productRepository;

  final wishlist = <ProductModel>[].obs;

  int get totalCount => wishlist.length;

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  HomeController? get _homeOrNull =>
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() => wishlist.assignAll(_productRepository.getWishlist());

  Future<void> removeFromWishlist(String id) async {
    await _productRepository.removeFromWishlist(id);
    loadWishlist();
    _homeOrNull?.favoriteIds.remove(id);
  }

  Future<void> moveToCart(ProductModel product) async {
    cartController.addItem(product);
    await removeFromWishlist(product.id);
  }

  void clearWishlist() {
    Get.defaultDialog(
      title: 'Kosongkan Wishlist?',
      titleStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      middleText: 'Apakah Anda yakin ingin menghapus seluruh sepatu favorit dari memori penyimpanan lokal?',
      textCancel: 'Batal',
      textConfirm: 'Hapus Semua',
      cancelTextColor: Colors.grey,
      buttonColor: const Color(0xFFEF4444),
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await _productRepository.clearWishlist();
        wishlist.clear();
        _homeOrNull?.favoriteIds.clear();
        Get.back();
        Get.snackbar(
          'Wishlist Dikosongkan',
          'Seluruh produk favorit berhasil dihapus dari penyimpanan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
        );
      },
    );
  }
}
