import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String price;
  final VoidCallback onTap;
  final Product product;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.onTap,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;
  static const int maxQuantity = 10;

  void _incrementQuantity() {
    if (quantity < maxQuantity) {
      setState(() {
        quantity++;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final price = double.tryParse(widget.price.split(' ')[0]) ?? 0.0;

      // Добавляем товар в корзину при первом нажатии
      if (quantity == 1) {
        cartProvider.addItem(widget.product.id.toString(), widget.name, price);
      } else {
        // Обновляем количество для существующего товара
        cartProvider.updateQuantity(widget.product.id.toString(), quantity);
      }
    }
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });

      Provider.of<CartProvider>(
        context,
        listen: false,
      ).updateQuantity(widget.product.id.toString(), quantity);
    }
  }

  Widget _buildQuantityControls() {
    if (quantity == 0) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF5CBCE5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: _incrementQuantity,
        ),
      );
    }

    return Container(
      height: 40,
      constraints: const BoxConstraints(maxWidth: 140),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, color: Color(0xFF484647)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _decrementQuantity,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32, // Увеличиваем с 24 до 32 для двузначных чисел
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF484647),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF484647)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: quantity < maxQuantity ? _incrementQuantity : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 180,
        height: 242,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: _buildImage(widget.imageUrl),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: Text(
                    widget.name,
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
            Row(
              mainAxisAlignment:
                  quantity == 0
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (quantity == 0)
                  Text(
                    _formatPrice(widget.price),
                    style: const TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF484647),
                    ),
                  ),
                _buildQuantityControls(),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
