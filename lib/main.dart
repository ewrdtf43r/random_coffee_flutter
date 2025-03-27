import 'package:flutter/material.dart';
import 'core/service_locator.dart'; // Импортируйте файл service_locator.dart
import 'presentation/ui/pages/category_page.dart';

void main() {
  setupServiceLocator(); // Вызовите setupServiceLocator() до runApp()
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoryPage(),
    );
  }
}