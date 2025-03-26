import 'package:flutter/material.dart';
import '../../../data/datasources/remote/category_remote_data_source.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_categories.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> _categories = [];
  late GetCategories _getCategories;
  late CategoryRepositoryImpl _categoryRepository;
  late CategoryRemoteDataSourceImpl _categoryRemoteDataSource;

  @override
  void initState() {
    super.initState();
    _categoryRemoteDataSource = CategoryRemoteDataSourceImpl(client: Dio());
    _categoryRepository =
        CategoryRepositoryImpl(remoteDataSource: _categoryRemoteDataSource);
    _getCategories = GetCategories(_categoryRepository);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final result = await _getCategories.execute();
    result.fold(
            (failure) => _handleFailure(failure),
            (categories) => _handleCategories(categories)
    );
  }

  void _handleFailure(Failure failure) {
    // Обработка ошибки
    print('Ошибка: $failure');
  }

  void _handleCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name ?? 'Нет названия'),
          );
        },
      ),
    );
  }
}