import 'package:dartz/dartz.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';
import '../../../core/errors/failures.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> execute() async {
    return await repository.getCategories();
  }
}