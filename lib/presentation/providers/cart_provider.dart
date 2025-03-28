import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(String productId, String name, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) {
        return CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          productId: productId,
          name: name,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }
}
