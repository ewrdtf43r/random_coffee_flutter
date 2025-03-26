import 'package:dartz/dartz.dart';
import '../entities/category.dart';
import '../../../core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();
}