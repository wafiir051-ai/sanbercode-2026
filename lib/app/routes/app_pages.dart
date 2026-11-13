import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

export 'app_routes.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterView(), binding: RegisterBinding()),
    GetPage(name: Routes.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: Routes.DETAIL, page: () => const DetailView(), binding: DetailBinding()),
    GetPage(name: Routes.CART, page: () => const CartView(), binding: CartBinding()),
    GetPage(name: Routes.WISHLIST, page: () => const WishlistView(), binding: WishlistBinding()),
  ];
}
