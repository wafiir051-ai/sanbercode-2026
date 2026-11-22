import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:e_commerce_smk/app/utils/currency.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Obx(() {
        if (controller.cart.items.isEmpty && !controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 72,
                  color: AppColors.lightTextMuted,
                ),
                const SizedBox(height: 12),
                const Text('Keranjang kosong, belum ada yang dibayar'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  child: const Text('Belanja Sekarang'),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section('Alamat Pengiriman', [
                  TextFormField(
                    controller: controller.nameController,
                    validator: controller.validateName,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama Penerima',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.phoneController,
                    validator: controller.validatePhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor WhatsApp',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.addressController,
                    validator: controller.validateAddress,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Lengkap',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.notesController,
                    decoration: const InputDecoration(
                      labelText: 'Catatan untuk kurir (opsional)',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                    ),
                  ),
                ]),
                _section('Pilih Kurir', [
                  for (var i = 0; i < controller.courierOptions.length; i++)
                    Obx(() {
                      final c = controller.courierOptions[i];
                      final selected =
                          controller.selectedCourierIndex.value == i;
                      return _optionTile(
                        selected: selected,
                        isDark: isDark,
                        onTap: () => controller.selectCourier(i),
                        title: c.name,
                        subtitle: c.estimatedTime,
                        trailing: formatRupiah(c.cost),
                      );
                    }),
                ]),
                _section('Metode Pembayaran', [
                  for (var i = 0; i < controller.paymentMethods.length; i++)
                    Obx(
                      () => _optionTile(
                        selected: controller.selectedPaymentMethod.value == i,
                        isDark: isDark,
                        onTap: () => controller.selectPayment(i),
                        title: controller.paymentMethods[i],
                      ),
                    ),
                ]),
                _section('Kupon Promo', [
                  Obx(() {
                    if (controller.appliedCouponCode.value.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withAlpha(120),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_offer_rounded,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Kupon ${controller.appliedCouponCode.value} aktif',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.removeCoupon,
                              child: const Text('Lepas'),
                            ),
                          ],
                        ),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.couponController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan kode kupon',
                              prefixIcon: Icon(
                                Icons.confirmation_number_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => controller.applyCoupon(
                              controller.couponController.text,
                            ),
                            child: const Text('Gunakan Kupon'),
                          ),
                        ),
                      ],
                    );
                  }),
                ]),
                _section('Ringkasan Pembayaran', [
                  Obx(
                    () => Column(
                      children: [
                        _buildPriceRow(
                          'Subtotal',
                          formatRupiah(controller.subtotal),
                          isDark,
                        ),
                        _buildPriceRow(
                          'PPN 11%',
                          formatRupiah(controller.tax),
                          isDark,
                        ),
                        _buildPriceRow(
                          'Ongkos Kirim',
                          formatRupiah(controller.courierFee),
                          isDark,
                        ),
                        if (controller.promoDiscount > 0)
                          _buildPriceRow(
                            'Potongan Promo Kupon',
                            '- ${formatRupiah(controller.promoDiscount)}',
                            isDark,
                            isDiscount: true,
                          ),
                        const Divider(height: 24),
                        _buildPriceRow(
                          'Total Tagihan',
                          formatRupiah(controller.grandTotal),
                          isDark,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 90),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cart.items.isEmpty && !controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.placeOrder,
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Bayar Sekarang - ${formatRupiah(controller.grandTotal)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _optionTile({
    required bool selected,
    required bool isDark,
    required VoidCallback onTap,
    required String title,
    String? subtitle,
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: selected ? 2 : 1,
            ),
            color: selected ? AppColors.primary.withAlpha(20) : null,
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (subtitle != null)
                      Text(subtitle, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              if (trailing != null)
                Text(
                  trailing,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    bool isDiscount = false,
  }) {
    final color = isDiscount
        ? AppColors.success
        : (isBold ? AppColors.primary : null);
    final style = TextStyle(
      fontSize: isBold ? 16 : 14,
      fontWeight: isBold || isDiscount ? FontWeight.w800 : FontWeight.w500,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
