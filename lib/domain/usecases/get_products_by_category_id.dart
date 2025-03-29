import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../core/errors/failures.dart'; // Импортируем Failure
class GetProductsByCategoryId {
  final ProductRepository repository;
  GetProductsByCategoryId(this.repository);
  Future<Either<Failure, List<Product>>> execute(int categoryId) async {
    return repository.getProductsByCategoryId(categoryId);
  }
}