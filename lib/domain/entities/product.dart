import 'package:equatable/equatable.dart';

import 'category.dart'; // Импортируем сущность Category

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final Category category; // Используем сущность Category
  final String imageUrl;
  final List<Price> prices;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.prices,
  });

  @override
  List<Object> get props => [id, name, description, category, imageUrl, prices];
}

// Вспомогательный класс для цены
class Price extends Equatable {
  final String value;
  final String currency;

  const Price({
    required this.value,
    required this.currency,
  });

  @override
  List<Object> get props => [value, currency];
}

// Убедитесь, что сущность Category также определена (если ещё нет)
class Category extends Equatable {
  final int id;
  final String slug;

  const Category({required this.id, required this.slug});

  @override
  List<Object?> get props => [id, slug];
}