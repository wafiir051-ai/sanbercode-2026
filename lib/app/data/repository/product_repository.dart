import '../../core/network/dio_exception.dart';
import '../../core/network/result.dart';
import '../models/product_model.dart';
import '../remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  const ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await _remoteDataSource.fetchProducts();
      return Success(products);
    } on NetworkFailure catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Gagal memuat katalog produk: ${e.toString()}');
    }
  }
}
