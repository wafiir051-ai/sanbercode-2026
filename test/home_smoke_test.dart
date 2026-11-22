import 'package:e_commerce_smk/app/core/network/result.dart';
import 'package:e_commerce_smk/app/core/services/auth_service.dart';
import 'package:e_commerce_smk/app/core/theme/app_theme.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/data/repository/product_repository.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _OfflineRepo extends Fake implements ProductRepository {
  @override
  bool get lastFetchFromCache => false;

  @override
  List<ProductModel> getWishlist() => [];

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async =>
      const Failure('Tidak ada koneksi');
}

void main() {
  testWidgets('beranda tampil, tambah ke keranjang menaikkan badge', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 6000);
    addTearDown(tester.view.reset);

    final onError = FlutterError.onError;
    FlutterError.onError = (d) {
      if (!d.exceptionAsString().contains('overflowed')) onError?.call(d);
    };
    addTearDown(() => FlutterError.onError = onError);

    Get.put<ProductRepository>(_OfflineRepo());
    Get.put<AuthService>(AuthService());
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: Routes.HOME,
        getPages: AppPages.routes,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Tidak ada koneksi'), findsOneWidget);
    expect(find.text('Katalog Sneakers'), findsOneWidget);
    expect(find.text('6 Produk'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_shopping_cart_rounded).first);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
