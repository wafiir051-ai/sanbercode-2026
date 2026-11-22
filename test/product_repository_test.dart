import 'dart:io';

import 'package:e_commerce_smk/app/core/network/dio_exception.dart';
import 'package:e_commerce_smk/app/core/network/result.dart';
import 'package:e_commerce_smk/app/data/local/product_local_datasource.dart';
import 'package:e_commerce_smk/app/data/models/product_model.dart';
import 'package:e_commerce_smk/app/data/remote/product_remote_datasource.dart';
import 'package:e_commerce_smk/app/data/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

class _FakeRemote implements ProductRemoteDataSource {
  bool offline = false;
  @override
  Future<List<ProductModel>> fetchProducts() async {
    if (offline) throw const NetworkFailure(code: -6, message: 'offline');
    return [_shoe('1'), _shoe('2')];
  }
}

ProductModel _shoe(String id) => ProductModel(
  id: id,
  name: 'Shoe $id',
  category: 'Running',
  price: 100000,
  rating: 4.5,
  imageUrl: 'x',
);

void main() {
  late Directory dir;
  late _FakeRemote remote;
  late ProductRepositoryImpl repo;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
    await Hive.openBox<ProductModel>(
      ProductLocalDataSourceImpl.productsBoxName,
    );
    await Hive.openBox<ProductModel>(
      ProductLocalDataSourceImpl.wishlistBoxName,
    );
    remote = _FakeRemote();
    repo = ProductRepositoryImpl(remote, ProductLocalDataSourceImpl());
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('offline memakai cache Hive yang disimpan saat online', () async {
    await repo.fetchProducts();
    expect(repo.lastFetchFromCache, isFalse);

    remote.offline = true;
    final result = await repo.fetchProducts();
    expect(result, isA<Success<List<ProductModel>, String>>());
    expect((result as Success<List<ProductModel>, String>).data.length, 2);
    expect(repo.lastFetchFromCache, isTrue);
  });

  test('offline tanpa cache mengembalikan Failure', () async {
    remote.offline = true;
    expect(
      await repo.fetchProducts(),
      isA<Failure<List<ProductModel>, String>>(),
    );
  });

  test('toggle, remove, dan clear wishlist persisten di Hive', () async {
    expect(await repo.toggleWishlist(_shoe('1')), isTrue);
    expect(await repo.toggleWishlist(_shoe('2')), isTrue);
    expect(repo.isFavorite('1'), isTrue);
    expect(repo.getWishlist().length, 2);

    expect(await repo.toggleWishlist(_shoe('1')), isFalse);
    expect(repo.getWishlist().map((e) => e.id), ['2']);

    await repo.clearWishlist();
    expect(repo.getWishlist(), isEmpty);
  });
}
