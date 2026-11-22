import 'package:e_commerce_smk/app/core/middleware/auth_middleware.dart';
import 'package:e_commerce_smk/app/core/services/auth_service.dart';
import 'package:e_commerce_smk/app/core/theme/app_theme.dart';
import 'package:e_commerce_smk/app/data/models/cart_item_model.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce_smk/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:e_commerce_smk/app/routes/app_pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shoe = ProductModel(
  id: 'shoe-01',
  name: 'Shoe',
  category: 'Running',
  price: 1000000,
  rating: 4.5,
  imageUrl: 'x',
);

void main() {
  tearDown(Get.reset);

  test('grand total mengikuti kurir dan kupon, tidak pernah negatif', () {
    final cart = Get.put(CartController());
    cart.items.add(CartItemModel(product: _shoe, selectedSize: '42'));
    final checkout = CheckoutController()..onInit();

    expect(checkout.grandTotal, 1000000 + 110000 + 25000);

    checkout.selectCourier(2);
    expect(checkout.courierFee, 35000);
    expect(checkout.grandTotal, 1000000 + 110000 + 35000);

    checkout.discountAmount.value = CheckoutController.coupons['SMKBISA']!;
    expect(checkout.grandTotal, 1000000 + 110000 + 35000 - 25000);

    checkout.discountAmount.value = 99999999;
    expect(checkout.grandTotal, 0);
  });

  test('validasi nomor WhatsApp dan alamat', () {
    final c = CheckoutController();
    expect(c.validatePhone('12345'), isNotNull);
    expect(c.validatePhone('081234567890'), isNull);
    expect(c.validatePhone('+6281234567890'), isNull);
    expect(c.validateAddress('Jl. A'), isNotNull);
    expect(c.validateAddress('Jl. Merdeka No. 10, Subang'), isNull);
  });

  testWidgets(
    'tamu dicegat ke login lalu dikembalikan ke checkout setelah masuk',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final auth = await AuthService().init(
        prefs: await SharedPreferences.getInstance(),
      );
      Get.put<AuthService>(auth);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: Routes.ORDERS,
          getPages: AppPages.routes,
        ),
      );
      await tester.pump();

      Get.toNamed(Routes.CHECKOUT);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Masuk untuk melanjutkan belanja'), findsOneWidget);
      expect(auth.redirectRoute, Routes.CHECKOUT);

      expect(AuthMiddleware().redirect(Routes.CHECKOUT), isNotNull);
      await auth.login('nama@sekolah.sch.id');
      expect(AuthMiddleware().redirect(Routes.CHECKOUT), isNull);
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
