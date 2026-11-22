import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/theme/app_theme.dart';
import 'package:e_commerce_smk/app/data/local/storage_service.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

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
