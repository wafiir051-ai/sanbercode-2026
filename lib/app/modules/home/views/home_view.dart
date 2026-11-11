import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/cart_badge_button.dart';
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
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: controller.openWishlist,
          ),
          CartBadgeButton(
            count: () => controller.cartCount,
            onPressed: controller.openCart,
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
                    final isFav = controller.isFavorite(product.id);
                    return ProductCard(
                      title: product.name,
                      category: product.category,
                      price: product.formattedPrice,
                      rating: product.rating,
                      imageUrl: product.imageUrl,
                      isFavorite: isFav,
                      onTap: () => controller.openDetail(product),
                      onAddToCart: () => controller.addToCart(product),
                      onToggleFavorite: () =>
                          controller.toggleFavorite(product.id),
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
