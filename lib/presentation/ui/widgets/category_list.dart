import 'package:flutter/material.dart';
import '../../../domain/entities/category.dart' as CategoryEntity;

class CategoryListWidget extends StatelessWidget {
  final List<CategoryEntity.Category> categories;

  const CategoryListWidget({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      height: 29,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isFirst = index == 0;

          return Container(
            // Убираем фиксированную ширину, делаем ширину по контенту
            height: 29,
            decoration: BoxDecoration(
              color: isFirst ? const Color(0xFF5CBCE5) : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            // Добавляем внутренние отступы для текста
            padding: const EdgeInsets.symmetric(horizontal: 16.0), //  16px слева и справа
            margin: EdgeInsets.only(right: index < categories.length - 1 ? 8.0 : 0), //  Отступ между элементами, кроме последнего
            child: Center(
              child: Text(
                category.slug,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 0.1,
                  color: isFirst ? Colors.white : const Color(0xFF484647),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}