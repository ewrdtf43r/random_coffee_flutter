import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../data/datasources/local/cart_local_data_source.dart';

class CartProvider extends ChangeNotifier {
  final CartLocalDataSource localDataSource;
  Map<String, CartItem> _items = {};
  final Set<String> _clearedItems = {};
  bool _wasCleared = false;

  CartProvider({required this.localDataSource}) {
    _loadCartFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    _items = localDataSource.loadCart();
    notifyListeners();
  }

  Future<void> _saveCartToStorage() async {
    await localDataSource.saveCart(_items);
  }

  Map<String, CartItem> get items => {..._items};
  bool get wasCleared => _wasCleared;

  int getItemQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  // Проверка, был ли товар очищен
  bool wasItemCleared(String productId) {
    return _clearedItems.contains(productId);
  }

  // Сброс состояния очистки для конкретного товара
  void resetClearedState(String productId) {
    _clearedItems.remove(productId);
  }

  @override
  void addItem(String productId, String name, double price, String imageUrl) {
    _clearedItems.remove(productId);

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          productId: existingItem.productId,
          name: existingItem.name,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          productId: productId,
          name: name,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
        ),
      );
    }
    _saveCartToStorage();
    notifyListeners();
  }

  @override
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
    } else {
      _clearedItems.remove(productId);
      if (_items.containsKey(productId)) {
        _items.update(
          productId,
          (existingItem) => CartItem(
            productId: existingItem.productId,
            name: existingItem.name,
            price: existingItem.price,
            imageUrl: existingItem.imageUrl,
            quantity: quantity,
          ),
        );
        _saveCartToStorage();
        notifyListeners();
      }
    }
  }

  @override
  void removeItem(String productId) {
    _items.remove(productId);
    _clearedItems.add(productId);
    _saveCartToStorage();
    notifyListeners();
  }

  @override
  void clear() {
    _clearedItems.addAll(_items.keys);
    _items.clear();
    _wasCleared = true;
    localDataSource.clearCart();
    notifyListeners();
    _wasCleared = false;
  }

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }
}
