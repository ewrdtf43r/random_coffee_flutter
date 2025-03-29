import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/cart_item.dart';

class CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cartKey = 'CART_ITEMS';

  CartLocalDataSource({required this.sharedPreferences});

  Future<bool> saveCart(Map<String, CartItem> items) async {
    final cartData = items.map(
      (key, item) => MapEntry(key, {
        'productId': item.productId,
        'name': item.name,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'quantity': item.quantity,
      }),
    );

    return await sharedPreferences.setString(cartKey, json.encode(cartData));
  }

  Map<String, CartItem> loadCart() {
    try {
      final cartString = sharedPreferences.getString(cartKey);
      if (cartString != null) {
        final Map<String, dynamic> decodedData = json.decode(cartString);
        return decodedData.map(
          (key, value) => MapEntry(
            key,
            CartItem(
              productId: value['productId'],
              name: value['name'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              quantity: value['quantity'],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
    return {};
  }

  Future<bool> clearCart() async {
    return await sharedPreferences.remove(cartKey);
  }
}
