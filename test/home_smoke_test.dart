import 'package:e_commerce_smk/app/core/theme/app_theme.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: Routes.HOME,
        getPages: AppPages.routes,
      ),
    );
    await tester.pump();

    expect(find.text('Katalog Sneakers'), findsOneWidget);
    expect(find.text('6 Produk'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_shopping_cart_rounded).first);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
