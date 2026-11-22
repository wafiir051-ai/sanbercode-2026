import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/home/controllers/home_controller.dart';

class WishlistView extends GetView<HomeController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist Favorit')),
      body: Obx(() {
        final items = controller.products
            .where((p) => controller.favoriteIds.contains(p['id']))
            .toList();
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
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    p['imageUrl'],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  p['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(fmt.format(p['price'])),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.error,
                  ),
                  onPressed: () => controller.toggleFavorite(p['id']),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
