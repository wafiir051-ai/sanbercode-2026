import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/currency.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = controller.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: controller.isFavorite ? Colors.redAccent : null,
                ),
                onPressed: controller.toggleFavorite,
              )),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                p['imageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(p['category'], style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(p['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text('${p['rating']}'),
            ],
          ),
          const SizedBox(height: 10),
          Text(formatRupiah(p['price'] as int),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Text(p['description'] ?? ''),
          const SizedBox(height: 20),
          const Text('Pilih Ukuran',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: controller.sizes.map((s) {
                  return ChoiceChip(
                    label: Text(s),
                    selected: controller.selectedSize.value == s,
                    onSelected: (_) => controller.selectSize(s),
                  );
                }).toList(),
              )),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: controller.decrementQuantity,
                    ),
                    Obx(() => Text(
                          '${controller.quantity.value}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: controller.incrementQuantity,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.addToCart,
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Tambah Keranjang'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
