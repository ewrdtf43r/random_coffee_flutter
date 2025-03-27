import 'package:dio/dio.dart';
// import 'package:your_app_name/core/errors/exceptions.dart'; // Убедитесь, что путь корректен
// import 'package:your_app_name/data/models/product_model.dart'; // Убедитесь, что путь корректен
import 'package:get_it/get_it.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProductsByCategoryId(int categoryId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProductsByCategoryId(int categoryId) async {
    try {
      final response = await client.get(
        '/products/',
        queryParameters: {
          'category': categoryId,
          'page': 0,
          'limit': 8,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        //  Здесь можно выполнить преобразование в DTO, если ProductModel не является DTO.
        //  В вашем случае ProductModel уже содержит только данные, поэтому его можно использовать как DTO.
        final productModels = (jsonData['data'] as List)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return productModels;
      } else {
        //  Бросаем исключение ServerException с информацией об ошибке
        throw ServerException(
          message: 'Ошибка сервера: ${response.statusMessage}', // Используем statusMessage для более подробного сообщения
          statusCode: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      //  Обработка ошибок DioException (ошибки на уровне HTTP)
      if (e.response != null) {
        throw ServerException(
          message: 'Ошибка сервера: ${e.response?.statusMessage}',
          statusCode: e.response!.statusCode!,
        );
      } else {
        //  Ошибки без ответа (например, проблемы с соединением)
        throw ServerException(
          message: 'Ошибка соединения: ${e.message}', //  Используем e.message для получения сообщения об ошибке
          statusCode: -1, // Или другой код, указывающий на ошибку соединения
        );
      }
    } catch (e) {
      //  Обработка других исключений (менее вероятно, но нужно предусмотреть)
      throw ServerException(
        message: 'Неизвестная ошибка: $e',
        statusCode: -1,
      );
    }
  }
}