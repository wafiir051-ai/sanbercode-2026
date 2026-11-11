import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/currency.dart';
import '../controllers/home_controller.dart';
import 'components/product_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KicksStore'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Get.snackbar(
                  'Keranjang',
                  'Total ${controller.cartCount.value} barang',
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),
              Obx(() {
                final count = controller.cartCount.value;
                if (count == 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    child: Text('$count',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((category) {
                      final isSelected =
                          controller.selectedCategory.value == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => controller.changeCategory(category),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
          Expanded(
            child: Obx(() {
              final items = controller.filteredProducts;
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.66,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final product = items[index];
                  return Obx(() {
                    final isFav = controller.isFavorite(product['id']);
                    return ProductCard(
                      title: product['name'],
                      category: product['category'],
                      price: formatRupiah(product['price'] as int),
                      rating: (product['rating'] as num).toDouble(),
                      imageUrl: product['imageUrl'],
                      isFavorite: isFav,
                      onTap: () => controller.openDetail(product),
                      onAddToCart: () => controller.addToCart(product),
                      onToggleFavorite: () =>
                          controller.toggleFavorite(product['id']),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
