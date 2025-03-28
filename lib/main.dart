import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/ui/pages/category_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    // Настраиваем базовый URL (если он у вас есть)
    dio.options.baseUrl = 'https://coffeeshop.academy.effective.band/api/v1';
    // Настраиваем заголовки (если нужно)
    dio.options.headers['Content-Type'] = 'application/json';
    return MaterialApp(home: CategoryPage(dio: dio));
  }
}
