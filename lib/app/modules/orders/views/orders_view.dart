import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/orders/controllers/orders_controller.dart';
import 'package:e_commerce_smk/app/utils/currency.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: Obx(() {
        final orders = controller.orders;
        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 72,
                  color: AppColors.lightTextMuted,
                ),
                SizedBox(height: 12),
                Text('Belum ada pesanan'),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final o = orders[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          o.id,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Diproses',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _date(o.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Divider(height: 20),
                    Text('${o.itemCount} pasang sepatu - ${o.courier}'),
                    Text(o.payment, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah(o.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
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
