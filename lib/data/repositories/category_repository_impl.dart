import 'package:dartz/dartz.dart';
import '../../domain/entities/category.dart' as CategoryEntity;
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_data_source.dart';
import '../models/category_model.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity.Category>>> getCategories() async {
    try {
      final remoteCategories = await remoteDataSource.getCategories();
      return Right(remoteCategories.map(_mapToEntity).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  CategoryEntity.Category _mapToEntity(CategoryModel model) {
    return CategoryEntity.Category(id: model.id, slug: model.slug);
  }
}
