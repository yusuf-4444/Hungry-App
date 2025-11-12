import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static Dio getDio() {
    Duration timeOut = Duration(seconds: 120);
    if (dio == null) {
      dio = Dio();
      dio!..options.connectTimeout = timeOut;
      dio!..options.receiveTimeout = timeOut;
      addDioHeaders();
      addAuthInterceptor();
      addInterceptor();
      return dio!;
    }
    return dio!;
  }

  static addDioHeaders() async {
    dio!.options.headers = {"Accept": "application/json"};
  }

  static addInterceptor() {
    dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
    );
  }

  static addAuthInterceptor() {
    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          final isGuest = await PrefHelper.isGuest();

          print('🔐 Token for request: ${token ?? 'null'}');
          print('👤 Guest mode: $isGuest');

          if (isGuest) {
            print('🎭 Guest mode - no authorization header');
            return handler.next(options);
          }

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
            print('✅ Authorization header added');
          } else {
            print('❌ No authorization header added');
          }

          return handler.next(options);
        },
      ),
    );
  }
}
