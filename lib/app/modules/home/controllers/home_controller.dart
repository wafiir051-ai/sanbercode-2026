import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final cartCount = 0.obs;
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;

  final categories = const ['Semua', 'Sneakers', 'Running', 'Casual', 'Basket'];

  final List<Map<String, dynamic>> products = [
    {
      'id': 'shoe-01',
      'name': 'Air Stride Pro',
      'category': 'Running',
      'price': 1299000,
      'rating': 4.7,
      'description': 'Sepatu lari ringan dengan bantalan responsif untuk jarak jauh.',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    },
    {
      'id': 'shoe-02',
      'name': 'Urban Classic',
      'category': 'Casual',
      'price': 899000,
      'rating': 4.5,
      'description': 'Sneakers kasual serbaguna untuk aktivitas harian.',
      'imageUrl': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600',
    },
    {
      'id': 'shoe-03',
      'name': 'Court Master',
      'category': 'Basket',
      'price': 1899000,
      'rating': 4.8,
      'description': 'Cengkeraman kuat dan support pergelangan untuk lapangan basket.',
      'imageUrl': 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=600',
    },
    {
      'id': 'shoe-04',
      'name': 'Street Low',
      'category': 'Sneakers',
      'price': 1099000,
      'rating': 4.4,
      'description': 'Sneakers low-top bergaya streetwear yang nyaman dipakai seharian.',
      'imageUrl': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600',
    },
    {
      'id': 'shoe-05',
      'name': 'Velocity Run',
      'category': 'Running',
      'price': 1599000,
      'rating': 4.6,
      'description': 'Upper breathable dan sol responsif untuk latihan harian.',
      'imageUrl': 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=600',
    },
    {
      'id': 'shoe-06',
      'name': 'Daily Walker',
      'category': 'Casual',
      'price': 749000,
      'rating': 4.3,
      'description': 'Ringan dan empuk, cocok untuk jalan santai.',
      'imageUrl': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=600',
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products;
    return products.where((p) => p['category'] == category).toList();
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

  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    cartCount.value += quantity;
    Get.snackbar(
      'Ditambahkan',
      '${product['name']} masuk keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void openDetail(Map<String, dynamic> product) {
    Get.toNamed(Routes.DETAIL, arguments: product);
  }
}
