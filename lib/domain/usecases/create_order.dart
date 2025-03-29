import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.createOrder();
  }
}
