import 'package:e_commerce_smk/app/core/network/dio_exception.dart';
import 'package:e_commerce_smk/app/core/network/result.dart';
import 'package:e_commerce_smk/app/data/local/product_local_datasource.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/data/remote/product_remote_datasource.dart';

abstract class ProductRepository {
  bool get lastFetchFromCache;

  Future<Result<List<ProductModel>, String>> fetchProducts();

  List<ProductModel> getWishlist();
  bool isFavorite(String id);

  Future<bool> toggleWishlist(ProductModel product);
  Future<void> removeFromWishlist(String id);
  Future<void> clearWishlist();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  bool _fromCache = false;

  @override
  bool get lastFetchFromCache => _fromCache;

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      if (products.isNotEmpty) await _localDataSource.cacheProducts(products);
      _fromCache = false;
      return Success(products);
    } catch (e) {
      final cached = _localDataSource.getCachedProducts();
      if (cached.isNotEmpty) {
        _fromCache = true;
        return Success(cached);
      }
      return Failure(
        e is NetworkFailure
            ? e.message
            : 'Gagal memuat katalog produk: ${e.toString()}',
      );
    }
  }

  @override
  List<ProductModel> getWishlist() => _localDataSource.getWishlist();

  @override
  bool isFavorite(String id) => _localDataSource.isInWishlist(id);

  @override
  Future<bool> toggleWishlist(ProductModel product) async {
    if (_localDataSource.isInWishlist(product.id)) {
      await _localDataSource.removeFromWishlist(product.id);
      return false;
    }
    await _localDataSource.saveToWishlist(product);
    return true;
  }

  @override
  Future<void> removeFromWishlist(String id) =>
      _localDataSource.removeFromWishlist(id);

  @override
  Future<void> clearWishlist() => _localDataSource.clearWishlist();
}
