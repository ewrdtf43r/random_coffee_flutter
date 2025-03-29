import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/ui/pages/category_page.dart';
import 'data/datasources/remote/order_remote_data_source.dart';
import 'data/repositories/order_repository_impl.dart';
import 'domain/usecases/create_order.dart';
import 'core/globals.dart';
import 'data/datasources/local/cart_local_data_source.dart';

void main() async {
  // Необходимо для использования SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final dio =
      Dio()
        ..options.baseUrl = 'https://coffeeshop.academy.effective.band/api/v1'
        ..options.headers['Content-Type'] = 'application/json';

  // Инициализируем SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Инициализируем CartLocalDataSource
  final cartLocalDataSource = CartLocalDataSource(
    sharedPreferences: sharedPreferences,
  );

  // Инициализируем остальные зависимости
  final orderDataSource = OrderRemoteDataSourceImpl(dio: dio);
  final orderRepository = OrderRepositoryImpl(
    remoteDataSource: orderDataSource,
  );
  final createOrder = CreateOrder(orderRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(localDataSource: cartLocalDataSource),
        ),
        Provider<CreateOrder>.value(value: createOrder),
      ],
      child: MyApp(dio: dio),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({Key? key, required this.dio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: CategoryPage(dio: dio),
    );
  }
}
