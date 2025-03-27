import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart'; // Добавлен импорт get_it
import '../../../data/datasources/remote/category_remote_data_source.dart';
import '../../../data/datasources/remote/product_remote_data_source.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/category.dart' as CategoryEntity;
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_products_by_category_id.dart';
import '../../../core/errors/failures.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryEntity.Category> _categories = [];
  Map<int, List<Product>> _productsByCategoryId = {};
  late GetCategories _getCategories;
  late GetProductsByCategoryId _getProductsByCategoryId;
  late CategoryRepositoryImpl _categoryRepository;
  late ProductRepositoryImpl _productRepository;
  late CategoryRemoteDataSourceImpl _categoryRemoteDataSource;
  late ProductRemoteDataSourceImpl _productRemoteDataSource;

  @override
  void initState() {
    super.initState();
    _categoryRemoteDataSource = CategoryRemoteDataSourceImpl(client: GetIt.I<Dio>()); // Используем get_it
    _productRemoteDataSource = ProductRemoteDataSourceImpl(client: GetIt.I<Dio>()); // Используем get_it
    _categoryRepository = CategoryRepositoryImpl(remoteDataSource: _categoryRemoteDataSource);
    _productRepository = ProductRepositoryImpl(remoteDataSource: _productRemoteDataSource);
    _getCategories = GetCategories(_categoryRepository);
    _getProductsByCategoryId = GetProductsByCategoryId(_productRepository);
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchCategories();
    await _fetchProductsForCategories();
  }

  Future<void> _fetchCategories() async {
    final result = await _getCategories.execute();
    result.fold(
          (failure) => _handleFailure(failure),
          (categories) => setState(() {
        _categories = categories;
      }),
    );
  }

  void _onGetProductsFailure(Failure failure, int categoryId) {
    _handleFailure(failure);
    setState(() {
      _productsByCategoryId[categoryId] = [];
    });
  }

  void _onGetProductsSuccess(List<Product> products, int categoryId) {
    setState(() {
      _productsByCategoryId[categoryId] = products;
    });
  }

  Future<void> _fetchProductsForCategories() async {
    for (final category in _categories) {
      final result = await _getProductsByCategoryId.execute(category.id);
      result.fold(
            (failure) {
          _handleFailure(failure);
          setState(() {
            _productsByCategoryId[category.id] = [];
          });
        },
            (products) {
          setState(() {
            _productsByCategoryId[category.id] = products;
          });
        },
      );
    }
  }

  void _handleFailure(Failure failure) {
    print('Ошибка: $failure');
    // TODO: Добавьте более информативную обработку ошибок, например, отображение SnackBar.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофе'),
      ),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final products = _productsByCategoryId[category.id] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category.slug,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (products.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Нет продуктов в данной категории'),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, productIndex) {
                      final product = products[productIndex];
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              product.imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.prices.isNotEmpty
                                  ? '${product.prices.first.value} ${product.prices.first.currency}'
                                  : 'Цена не указана',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}