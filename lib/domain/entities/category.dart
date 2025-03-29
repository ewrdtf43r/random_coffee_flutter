import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String slug;

  const Category({
    required this.id,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, slug];
}