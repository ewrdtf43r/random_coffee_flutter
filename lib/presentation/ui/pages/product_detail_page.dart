import 'package:flutter/material.dart';
import '../../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 108,
            child: Container(
              width: 412,
              height: 458,
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  Изображение продукта
                  Container(
                    width: 218,
                    height: 218,
                    alignment: Alignment.center,
                    child: _buildImage(product.imageUrl),
                  ),
                  const SizedBox(height: 64),

                  //  Название и описание
                  Container(
                    width: 412,
                    height: 176,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 32,
                            fontWeight: FontWeight.normal,
                            height: 40 / 32,
                            color: Color(0xFF484647),
                          ),
                        ),
                        const SizedBox(height: 16),
                        //  Описание продукта  <---  Изменено
                        if (product.description.isNotEmpty)
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 24 / 16,
                              letterSpacing: 0.5,
                              color: Color(0xFF484647),
                            ),
                          )
                        else
                          const Text(
                            "Описание отсутствует",
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 24 / 16,
                              letterSpacing: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Методы _buildImage и _formatPrice остаются без изменений
  Widget _buildImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Icon(Icons.image, size: 100, color: Colors.grey);
        },
      );
    } else {
      return const Icon(Icons.image, size: 100, color: Colors.grey);
    }
  }

  String _formatPrice(String priceString) {
    try {
      final parts = priceString.split(' ');
      if (parts.length == 2) {
        final value = double.tryParse(parts[0]);
        if (value != null) {
          final roundedValue = value.round();
          return '$roundedValue ${parts[1].replaceAll("RUB", "₽")}';
        }
      }
    } catch (e) {
      print('Error formatting price: $e');
    }
    return priceString.replaceAll('RUB', '₽');
  }
}