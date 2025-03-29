import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../../domain/usecases/create_order.dart';
import '../../../domain/entities/cart_item.dart';
import 'custom_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFAEAAAB),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Order Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ваш заказ',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 32 / 24,
                    color: Color(0xFF484647),
                  ),
                ),
                SizedBox(
                  width: 31,
                  height: 32,
                  child: IconButton(
                    onPressed: () {
                      final cartProvider = context.read<CartProvider>();
                      cartProvider.clear();
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'lib/presentation/ui/icons/bin.svg',
                      width: 24,
                      height: 24,
                      // Используем цвет как в дизайне
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFAEAAAB),
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),

          // Orders List
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Корзина пуста',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF484647),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items.values.elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Container(
                        height: 79,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Product Info
                            // Product Info
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          height: 1.35,
                                          letterSpacing: 0.15,
                                          color: Color(0xFF484647),
                                        ),
                                      ),
                                      // Показываем количество только если оно больше 1
                                      if (item.quantity > 1) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          item.quantity.toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 1.35,
                                            letterSpacing: 0.15,
                                            color: Color(0xFF484647),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${(item.price * item.quantity).round()} ₽',
                                    style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                      letterSpacing: 0.15,
                                      color: Color(0xFF484647),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Total Sum
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Итого',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                              letterSpacing: 0.15,
                              color: Color(0xFF484647),
                            ),
                          ),
                          Text(
                            '${cart.totalAmount.round()} ₽',
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              letterSpacing: 0.15,
                              color: Color(0xFF484647),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Order Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _handleCreateOrder(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CBCE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: const Text(
                      'Оформить заказ',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 28 / 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateOrder(BuildContext context) async {
    try {
      final createOrder = context.read<CreateOrder>();
      final cartProvider = context.read<CartProvider>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFF5CBCE5)),
            ),
      );

      final result = await createOrder();

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (!context.mounted) return;

      result.fold(
        (failure) {
          CustomSnackBar.error(context, failure.message);
        },
        (orderId) {
          cartProvider.clear();
          Navigator.of(context).pop();
          CustomSnackBar.success(context, 'Заказ успешно создан');
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      developer.log('Неожиданная ошибка при создании заказа', error: e);

      if (!context.mounted) return;
      CustomSnackBar.error(context, 'Возникла ошибка при заказе');
    }
  }
}
