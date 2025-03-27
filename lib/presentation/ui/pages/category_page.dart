import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// ... другие импорты ...
import '../../../data/datasources/remote/category_remote_data_source.dart';
import '../../../domain/entities/category.dart' as CategoryEntity;
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_products_by_category_id.dart';
import '../../../core/errors/failures.dart';
import '../widgets/product_card.dart';
import '../widgets/category_list.dart';
import '../widgets/theme_toggle_button.dart';
// Добавленные импорты:
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/remote/product_remote_data_source.dart';
// ... остальные импорты ...
class CategoryPage extends StatefulWidget {
  final Dio dio;

  const CategoryPage({Key? key, required this.dio}) : super(key: key);

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
    _categoryRemoteDataSource = CategoryRemoteDataSourceImpl(client: widget.dio);
    _productRemoteDataSource = ProductRemoteDataSourceImpl(client: widget.dio);
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

  Future<void> _fetchProductsForCategories() async {
    for (final category in _categories) {
      final result = await _getProductsByCategoryId.execute(category.id);
      result.fold(
            (failure) => _onGetProductsFailure(failure, category.id),
            (products) => _onGetProductsSuccess(products, category.id),
      );
    }
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

  void _handleFailure(Failure failure) {
    print('Ошибка: $failure');
    // TODO: Добавьте более информативную обработку ошибок, например, отображение SnackBar.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Горизонтальный список категорий (прижат к верху, отступ 16px)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: CategoryListWidget(categories: _categories),
          ),

          // Вертикальный список (ниже горизонтального, занимает все оставшееся пространство)
          Positioned(
            top: 16 + 29 + 16, // Отступ: отступ CategoryList + высота CategoryList + зазор между списками
            left: 16,
            right: 16,
            bottom: 0,
            child: _categories.isEmpty
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        category.slug,
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.normal,
                          fontSize: 32,
                          height: 40 / 32,
                          color: Color(0xFF484647),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 16,
                      ),
                      padding: EdgeInsets.zero,
                      itemCount: products.length,
                      itemBuilder: (context, productIndex) {
                        final product = products[productIndex];
                        return ProductCard(
                          name: product.name,
                          imageUrl: product.imageUrl,
                          price: product.prices.isNotEmpty
                              ? '${product.prices.first.value} ${product.prices.first.currency}'
                              : 'Цена не указана',
                        );
                      },
                    ),
                    if (index < _categories.length - 1) const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
          // Кнопка смены темы (левый нижний угол, статичная)
          Positioned(
            left: 16,
            bottom: 32,
            child: ThemeToggleButton(
              onPressed: () {
                // TODO: Реализуйте логику смены темы
                print("Смена темы нажата!");
              },
            ),
          ),
        ],
      ),
    );
  }
}