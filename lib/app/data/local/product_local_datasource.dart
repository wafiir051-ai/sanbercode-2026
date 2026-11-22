import 'package:hive_ce/hive.dart';

import 'package:e_commerce_smk/app/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  List<ProductModel> getCachedProducts();

  List<ProductModel> getWishlist();
  bool isInWishlist(String id);
  Future<void> saveToWishlist(ProductModel product);
  Future<void> removeFromWishlist(String id);
  Future<void> clearWishlist();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxName = 'products_box';
  static const String wishlistBoxName = 'wishlist_box';

  Box<ProductModel> get _productsBox => Hive.box<ProductModel>(productsBoxName);
  Box<ProductModel> get _wishlistBox => Hive.box<ProductModel>(wishlistBoxName);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _productsBox.clear();
    await _productsBox.putAll({for (final p in products) p.id: p});
  }

  @override
  List<ProductModel> getCachedProducts() => _productsBox.values.toList();

  @override
  List<ProductModel> getWishlist() => _wishlistBox.values.toList();

  @override
  bool isInWishlist(String id) => _wishlistBox.containsKey(id);

  @override
  Future<void> saveToWishlist(ProductModel product) =>
      _wishlistBox.put(product.id, product.copyWith(isFavorite: true));

  @override
  Future<void> removeFromWishlist(String id) => _wishlistBox.delete(id);

  @override
  Future<void> clearWishlist() async {
    await _wishlistBox.clear();
  }
}
