import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String price;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 242,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20.0),  //  Заменяем margin на padding для внутренних отступов
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product
          Column(
            children: [
              // Picture Frame
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: _buildImage(imageUrl),
              ),
              const SizedBox(height: 8),
              // Кофе (название)
              SizedBox(
                height: 28,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF484647),
                    height: 28 / 22,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          // Bottom card elements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _formatPrice(price),
                  style: const TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF484647),
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildAddButton(), //  Используем отдельный метод для кнопки
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,  //  Обеспечиваем отображение всей картинки
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Icon(Icons.image, size: 50, color: Colors.grey);
        },
      );
    } else {
      return const Icon(Icons.image, size: 50, color: Colors.grey);
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

  Widget _buildAddButton() {  //  Отдельный метод для кнопки "Купить"
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF5CBCE5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),  //  Иконка "+"
        onPressed: () {
          print('Купить $name');
        },
      ),
    );
  }
}