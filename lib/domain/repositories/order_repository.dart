import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, String>> createOrder();
}
