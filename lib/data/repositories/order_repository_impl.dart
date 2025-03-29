import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createOrder() async {
    try {
      final response = await remoteDataSource.createOrder();
      return Right(response.orderId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
