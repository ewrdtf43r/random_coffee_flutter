import 'package:flutter/material.dart';
import '../../../domain/entities/category.dart' as CategoryEntity; // Добавляем импорт с псевдонимом

class CategoryListWidget extends StatelessWidget {
  final List<CategoryEntity.Category> categories; // Используем CategoryEntity.Category

  const CategoryListWidget({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.slug), // Заменяем name на slug
        );
      },
    );
  }
}