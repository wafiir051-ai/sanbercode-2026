import 'package:e_commerce_smk/app/core/network/dio_exception.dart';
import 'package:e_commerce_smk/app/core/network/result.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/data/remote/product_remote_datasource.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  const ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      return Success(await _remoteDataSource.fetchProducts());
    } on NetworkFailure catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Gagal memuat katalog produk: $e');
    }
  }
}
