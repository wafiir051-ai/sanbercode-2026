import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:e_commerce_smk/app/widgets/cart_badge_button.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Wishlist Favorit (${controller.totalCount})')),
        actions: [
          CartBadgeButton(
            count: () => controller.cartController.totalItemCount,
            onPressed: () => Get.toNamed(Routes.CART),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        final items = controller.wishlistItems;
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 72,
                  color: AppColors.lightTextMuted,
                ),
                SizedBox(height: 12),
                Text('Belum ada sepatu favorit'),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = items[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        p.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            p.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.formattedPrice,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () => controller.moveToCart(p),
                              icon: const Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 16,
                              ),
                              label: const Text('Ke Keranjang'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.error,
                      ),
                      onPressed: () => controller.removeFromWishlist(p.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
