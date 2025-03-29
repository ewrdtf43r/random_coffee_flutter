import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/order_response_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderResponseModel> createOrder();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  @override
  Future<OrderResponseModel> createOrder() async {
    try {
      developer.log('Отправка запроса на создание заказа');

      final response = await dio
          .post(
            '/orders',
            data: {'preserve': true},
            options: Options(
              headers: {'Content-Type': 'application/json'},
              validateStatus: (status) => true,
            ),
          )
          .timeout(const Duration(seconds: 10));

      developer.log('Получен ответ от сервера: ${response.statusCode}');
      developer.log('Тело ответа: ${response.data}');

      if (response.statusCode == 201) {
        return OrderResponseModel.fromJson(response.data);
      }

      String errorMessage = 'Произошла ошибка при создании заказа';
      if (response.statusCode == 500) {
        errorMessage = 'Сервер временно недоступен. Попробуйте позже';
      } else if (response.data != null && response.data['detail'] != null) {
        errorMessage = response.data['detail'].toString();
      }

      throw ServerException(
        message: errorMessage,
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      developer.log('DioException при создании заказа: ${e.message}');
      String message = 'Ошибка подключения к серверу';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        message = 'Превышено время ожидания. Проверьте подключение';
      }
      throw ServerException(message: message, statusCode: 503);
    } catch (e, stack) {
      developer.log(
        'Неожиданная ошибка при создании заказа',
        error: e,
        stackTrace: stack,
      );
      throw ServerException(
        message: 'Произошла непредвиденная ошибка',
        statusCode: 500,
      );
    }
  }
}
