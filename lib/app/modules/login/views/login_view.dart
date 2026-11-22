import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_colors.dart';
import 'package:e_commerce_smk/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.electric_bolt_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'KicksStore',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masuk untuk melanjutkan belanja',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: controller.emailController,
                    validator: controller.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      validator: controller.validatePassword,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: controller.goToRegister,
                    child: const Text('Belum punya akun? Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
