import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/services/auth_service.dart';
import 'package:e_commerce_smk/app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (AuthService.to.isLoggedIn.value || route == Routes.LOGIN) return null;

    AuthService.to.redirectRoute = route;
    Get.snackbar(
      'Akses Dibatasi',
      'Silakan masuk akun terlebih dahulu untuk melanjutkan proses pemesanan.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E293B),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.lock_outline_rounded, color: Colors.orangeAccent),
    );
    return const RouteSettings(name: Routes.LOGIN);
  }
}
