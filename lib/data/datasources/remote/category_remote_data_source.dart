import 'dart:convert';
//import 'package:http/http.dart' as http; // <- Удалите эту строку
import 'package:dio/dio.dart'; // <- Добавьте эту строку
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
      final response = await client.get(
        'https://coffeeshop.academy.effective.band/api/v1/products/categories?page=0&limit=25',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = response.data;

        final List<dynamic> data = json['data'];

        return data.map((category) => CategoryModel.fromJson(category)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if(e.response != null){
        throw ServerException();
      }
      else {
        throw Exception();
      }
    }
  }
}