import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/orders/controllers/orders_controller.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:e_commerce_smk/app/utils/currency.dart';

class CourierOption {
  final String name;
  final String estimatedTime;
  final int cost;

  const CourierOption({
    required this.name,
    required this.estimatedTime,
    required this.cost,
  });
}

class CheckoutController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController notesController;
  late final TextEditingController couponController;

  final selectedCourierIndex = 0.obs;
  final selectedPaymentMethod = 0.obs;
  final isLoading = false.obs;

  final discountAmount = 0.obs;
  final appliedCouponCode = ''.obs;

  static const Map<String, int> coupons = {'SMKBISA': 25000, 'KICKS10': 25000};

  final List<CourierOption> courierOptions = const [
    CourierOption(
      name: 'JNE Reguler',
      estimatedTime: '2-3 hari kerja',
      cost: 25000,
    ),
    CourierOption(
      name: 'SiCepat BEST',
      estimatedTime: '1-2 hari kerja',
      cost: 22000,
    ),
    CourierOption(
      name: 'GoSend Instant',
      estimatedTime: 'Tiba hari ini (Instant 3-4 jam)',
      cost: 35000,
    ),
  ];

  final List<String> paymentMethods = const [
    'Transfer Bank (Virtual Account)',
    'E-Wallet (GoPay / OVO)',
    'COD (Bayar di Tempat)',
  ];

  CartController get cart => Get.find<CartController>();

  int get subtotal => cart.subtotal;
  int get tax => cart.tax;
  int get courierFee =>
      cart.items.isEmpty ? 0 : courierOptions[selectedCourierIndex.value].cost;
  int get promoDiscount => discountAmount.value;
  int get grandTotal => max(0, subtotal + tax + courierFee - promoDiscount);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    notesController = TextEditingController();
    couponController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    couponController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama penerima wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }
    if (!RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$').hasMatch(value.trim())) {
      return 'Format nomor tidak valid (contoh: 081234567890)';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat lengkap wajib diisi';
    }
    if (value.trim().length < 10) {
      return 'Alamat terlalu singkat (minimal 10 karakter)';
    }
    return null;
  }

  void selectCourier(int index) => selectedCourierIndex.value = index;

  void selectPayment(int index) => selectedPaymentMethod.value = index;

  void applyCoupon(String couponCode) {
    final code = couponCode.trim().toUpperCase();
    final discount = coupons[code];

    if (discount == null) {
      Get.snackbar(
        'Kupon Tidak Valid',
        'Kode kupon promo tidak ditemukan atau telah kedaluwarsa.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      );
      return;
    }

    discountAmount.value = discount;
    appliedCouponCode.value = code;
    Get.snackbar(
      'Kupon Berhasil Dipasang! 🎉',
      'Hemat ${formatRupiah(discount)} untuk pesanan sneakers impianmu.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.local_offer_rounded, color: Colors.white),
    );
  }

  void removeCoupon() {
    discountAmount.value = 0;
    appliedCouponCode.value = '';
    couponController.clear();
  }

  Future<void> placeOrder() async {
    if (cart.items.isEmpty) return;
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    final orderId = 'KS-${DateTime.now().millisecondsSinceEpoch % 100000000}';
    OrdersController.ensure().addOrder(
      OrderRecord(
        id: orderId,
        createdAt: DateTime.now(),
        itemCount: cart.totalItemCount,
        total: grandTotal,
        courier: courierOptions[selectedCourierIndex.value].name,
        payment: paymentMethods[selectedPaymentMethod.value],
        address: addressController.text.trim(),
      ),
    );
    await cart.clearCartAsync();
    isLoading.value = false;

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 64,
              color: AppColors.success,
            ),
            SizedBox(height: 12),
            Text('Pesanan Sukses!'),
          ],
        ),
        content: Text(
          'Pesanan $orderId berhasil dibuat. Terima kasih sudah berbelanja di KicksStore.',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Lihat Pesanan'),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    Get.offNamedUntil(
      Routes.ORDERS,
      (route) => route.settings.name == Routes.HOME,
    );
  }
}
