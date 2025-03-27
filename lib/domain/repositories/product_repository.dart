import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../../core/errors/failures.dart'; // Добавлен импорт
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProductsByCategoryId(int categoryId);
}