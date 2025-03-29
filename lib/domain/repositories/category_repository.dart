import 'package:dartz/dartz.dart';
import '../entities/category.dart' as CategoryEntity; // Добавлен импорт с псевдонимом
import '../../../core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity.Category>>> getCategories(); // Используем CategoryEntity.Category
}