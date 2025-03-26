import 'package:flutter/material.dart';
import '../../../domain/entities/category.dart';

class CategoryListWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoryListWidget({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.name),
        );
      },
    );
  }
}