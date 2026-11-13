import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/result.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  HomeController(this._productRepository);

  final ProductRepository _productRepository;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final products = <ProductModel>[].obs;
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;

  static const List<ProductModel> _initialFallbackProducts = [
    ProductModel(
      id: 'shoe-01',
      name: 'Air Stride Pro',
      category: 'Running',
      price: 1299000,
      rating: 4.7,
      description: 'Sepatu lari ringan dengan bantalan responsif untuk jarak jauh.',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    ),
    ProductModel(
      id: 'shoe-02',
      name: 'Urban Classic',
      category: 'Casual',
      price: 899000,
      rating: 4.5,
      description: 'Sneakers kasual serbaguna untuk aktivitas harian.',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600',
    ),
    ProductModel(
      id: 'shoe-03',
      name: 'Court Master',
      category: 'Basket',
      price: 1899000,
      rating: 4.8,
      description: 'Cengkeraman kuat dan support pergelangan untuk lapangan basket.',
      imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=600',
    ),
    ProductModel(
      id: 'shoe-04',
      name: 'Street Low',
      category: 'Sneakers',
      price: 1099000,
      rating: 4.4,
      description: 'Sneakers low-top bergaya streetwear yang nyaman dipakai seharian.',
      imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600',
    ),
  ];

  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  int get cartCount => cartController.totalItemCount;

  List<String> get categories =>
      ['Semua', ...products.map((p) => p.category).toSet()];

  List<ProductModel> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products;
    return products.where((p) => p.category == category).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final hadProducts = products.isNotEmpty;
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _productRepository.fetchProducts();

    switch (result) {
      case Success(data: final remoteProducts):
        if (remoteProducts.isNotEmpty) {
          products.assignAll(remoteProducts);
          selectedCategory.value = 'Semua';
          Get.snackbar(
            'Katalog Berhasil Diperbarui',
            'Berhasil mengunduh ${remoteProducts.length} sepatu terbaru dari server!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
          );
        }
      case Failure(error: final error):
        errorMessage.value = error;
        if (hadProducts) {
          Get.snackbar(
            'Mode Offline',
            'Koneksi ke server terputus. Menampilkan data yang sudah ada.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
          );
        } else {
          products.assignAll(_initialFallbackProducts);
        }
    }

    isLoading.value = false;
  }

  void changeCategory(String category) => selectedCategory.value = category;

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }

  void addToCart(ProductModel product) {
    cartController.addItem(product);
  }

  void openDetail(ProductModel product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }

  void openCart() => Get.toNamed(Routes.CART);

  void openWishlist() => Get.toNamed(Routes.WISHLIST);
}
