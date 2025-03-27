import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:your_app_name/core/network/network_info.dart'; // Импорт NetworkInfo, если он нужен для Dio

final getIt = GetIt.instance;

void setupServiceLocator() {
  //  Регистрируем Dio как Singleton.  Singleton означает, что будет создан только один экземпляр Dio,
  // который будет использоваться во всем приложении.
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: 'https://coffeeshop.academy.effective.band/api/v1/',
        // Здесь можно добавить другие настройки Dio, такие как таймауты, заголовки и т.д.
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        // Если вам нужен NetworkInfo для Dio, раскомментируйте строки ниже и передайте его в интерцептор.
        // validateStatus: (status) => status != null && status >= 200 && status < 300, // Пример: только коды 2xx считаются успешными
      ),
    )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true)), // Добавим логгер для отладки
    //  Если вы хотите добавить интерцептор, например, для обработки ошибок или
    //  для добавления заголовков авторизации, сделайте это здесь.
    //  Например:
    //  ..interceptors.add(AuthInterceptor(getIt<AuthService>()))
    //  Если вам нужен интерцептор, который зависит от NetworkInfo, раскомментируйте
    //  код ниже и добавьте NetworkInfo в Service Locator.
    // ..interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       final networkInfo = getIt<NetworkInfo>();
    //       if (await networkInfo.isConnected) {
    //         return handler.next(options);
    //       } else {
    //         return handler.reject(DioException(
    //           requestOptions: options,
    //           error: 'Нет подключения к интернету',
    //         ));
    //       }
    //     },
    //   ),
    // ),
  );

  //  Регистрация NetworkInfo (если она нужна для Dio или других сервисов):
  //  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt<Connectivity>()));
  //  Вам также потребуется добавить пакет connectivity_plus в pubspec.yaml, если вы его еще не используете:
  //  flutter pub add connectivity_plus
  //  и создать реализацию NetworkInfoImpl (см. пример ниже).

  //  Здесь можно зарегистрировать другие сервисы, репозитории и т.д.  по мере необходимости.
  //  Например:
  //  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(getIt<AuthRemoteDataSource>()));
  //  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthService>()));
}

//  Пример реализации NetworkInfoImpl (если NetworkInfo нужен для Dio):
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:your_app_name/core/network/network_info.dart';
//
// class NetworkInfoImpl implements NetworkInfo {
//   final Connectivity connectivity;
//
//   NetworkInfoImpl(this.connectivity);
//
//   @override
//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }