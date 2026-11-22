import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_theme.dart';
import 'package:e_commerce_smk/app/core/services/auth_service.dart';
import 'package:e_commerce_smk/app/data/local/cart_local_datasource.dart';
import 'package:e_commerce_smk/app/data/local/storage_service.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:e_commerce_smk/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  await Get.putAsync<AuthService>(() => AuthService().init(), permanent: true);
  Get.put<CartLocalDataSource>(CartLocalDataSourceImpl(), permanent: true);

  runApp(
    GetMaterialApp(
      title: 'KicksStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: storage.themeMode,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
