import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/cart_badge_button.dart';
import '../controllers/home_controller.dart';
import 'components/product_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
            child: RefreshIndicator(
              onRefresh: controller.fetchProducts,
              child: Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Memuat katalog sneakers dari server...'),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.products.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(32),
                    children: [
                      const SizedBox(height: 80),
                      Icon(Icons.wifi_off_rounded, size: 56, color: scheme.error),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal Memuat Produk',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: controller.fetchProducts,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Coba Lagi'),
                        ),
                      ),
                    ],
                  );
                }

                final items = controller.filteredProducts;
                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
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
          ),
        ],
      ),
    );
  }
}
