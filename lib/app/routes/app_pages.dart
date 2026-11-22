import 'package:get/get.dart';

import 'package:e_commerce_smk/app/modules/cart/views/cart_view.dart';
import 'package:e_commerce_smk/app/modules/detail/bindings/detail_binding.dart';
import 'package:e_commerce_smk/app/modules/detail/views/detail_view.dart';
import 'package:e_commerce_smk/app/modules/home/bindings/home_binding.dart';
import 'package:e_commerce_smk/app/modules/home/views/home_view.dart';
import 'package:e_commerce_smk/app/modules/login/views/login_view.dart';
import 'package:e_commerce_smk/app/modules/orders/views/orders_view.dart';
import 'package:e_commerce_smk/app/modules/wishlist/bindings/wishlist_binding.dart';
import 'package:e_commerce_smk/app/modules/wishlist/views/wishlist_view.dart';

export 'app_routes.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => const LoginView()),
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
    GetPage(name: Routes.CART, page: () => const CartView()),
    GetPage(
      name: Routes.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(name: Routes.ORDERS, page: () => const OrdersView()),
  ];
}
