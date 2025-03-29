import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategoryId(
    int categoryId,
  ) async {
    try {
      final productModels = await remoteDataSource.getProductsByCategoryId(
        categoryId,
      );
      final products =
          productModels.map((model) => _mapToEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  Product _mapToEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      category: Category(id: model.category.id, slug: model.category.slug),
      imageUrl: model.imageUrl,
      prices:
          model.prices
              .map(
                (priceModel) => Price(
                  value: priceModel.value,
                  currency: priceModel.currency,
                ),
              )
              .toList(),
    );
  }
}
