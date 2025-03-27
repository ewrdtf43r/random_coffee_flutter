import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String slug;

  const CategoryModel({
    required this.id,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
    );
  }

  @override
  List<Object?> get props => [id, slug];
}