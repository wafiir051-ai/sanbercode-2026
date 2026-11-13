import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Buat akun baru',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Isi data berikut untuk mulai berbelanja',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: controller.nameController,
                  validator: controller.validateName,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Contoh: Budi Santoso',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email',
                    hintText: 'nama@sekolah.sch.id',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      validator: controller.validatePassword,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        hintText: 'Minimal 6 karakter dan 1 angka',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      validator: controller.validateConfirmPassword,
                      obscureText: controller.isConfirmHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Kata Sandi',
                        hintText: 'Ulangi kata sandi',
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isConfirmHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: controller.toggleConfirmVisibility,
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                Obx(() => SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Daftar'),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
