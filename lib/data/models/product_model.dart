import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final CategoryModel category;
  final String imageUrl;
  final List<PriceModel> prices;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.prices,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>), // Используем CategoryModel для вложенной категории
      imageUrl: json['imageUrl'] as String,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => PriceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object> get props => [id, name, description, category, imageUrl, prices];
}

// Вспомогательная модель для цены
class PriceModel extends Equatable {
  final String value;
  final String currency;

  const PriceModel({
    required this.value,
    required this.currency,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      value: json['value'] as String,
      currency: json['currency'] as String,
    );
  }

  @override
  List<Object> get props => [value, currency];
}

// Убедитесь, что CategoryModel также имеет фабричный конструктор fromJson
class CategoryModel extends Equatable {
  final int id;
  final String slug;

  const CategoryModel({required this.id, required this.slug});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
    );
  }

  @override
  List<Object?> get props => [id, slug];
}