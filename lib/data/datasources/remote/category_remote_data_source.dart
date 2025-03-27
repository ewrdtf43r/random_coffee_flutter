import 'package:dio/dio.dart';
import '../../models/category_model.dart';
import '../../../core/errors/exceptions.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get('/products/categories');

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final categories = (jsonData['data'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return categories;
      } else {
        throw ServerException(
          message: 'Ошибка сервера: ${response.statusMessage}',
          statusCode: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          message: 'Ошибка сервера: ${e.response?.statusMessage}',
          statusCode: e.response!.statusCode!,
        );
      } else {
        throw ServerException(
          message: 'Ошибка соединения: ${e.message}',
          statusCode: -1,
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Неизвестная ошибка: $e',
        statusCode: -1,
      );
    }
  }
}