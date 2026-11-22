import 'package:get/get.dart';

import 'package:e_commerce_smk/app/core/middleware/auth_middleware.dart';
import 'package:e_commerce_smk/app/modules/cart/bindings/cart_binding.dart';
import 'package:e_commerce_smk/app/modules/cart/views/cart_view.dart';
import 'package:e_commerce_smk/app/modules/checkout/bindings/checkout_binding.dart';
import 'package:e_commerce_smk/app/modules/checkout/views/checkout_view.dart';
import 'package:e_commerce_smk/app/modules/detail/bindings/detail_binding.dart';
import 'package:e_commerce_smk/app/modules/detail/views/detail_view.dart';
import 'package:e_commerce_smk/app/modules/home/bindings/home_binding.dart';
import 'package:e_commerce_smk/app/modules/home/views/home_view.dart';
import 'package:e_commerce_smk/app/modules/login/bindings/login_binding.dart';
import 'package:e_commerce_smk/app/modules/login/views/login_view.dart';
import 'package:e_commerce_smk/app/modules/orders/bindings/orders_binding.dart';
import 'package:e_commerce_smk/app/modules/orders/views/orders_view.dart';
import 'package:e_commerce_smk/app/modules/register/bindings/register_binding.dart';
import 'package:e_commerce_smk/app/modules/register/views/register_view.dart';
import 'package:e_commerce_smk/app/modules/wishlist/bindings/wishlist_binding.dart';
import 'package:e_commerce_smk/app/modules/wishlist/views/wishlist_view.dart';

export 'app_routes.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: Routes.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
