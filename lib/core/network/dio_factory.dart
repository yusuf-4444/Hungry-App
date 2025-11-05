import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static Dio getDio() {
    Duration timeOut = Duration(minutes: 1);
    if (dio == null) {
      dio = Dio();
      dio!..options.connectTimeout = timeOut;
      dio!..options.receiveTimeout = timeOut;
      addDioHeaders();
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
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
      ),
    );
  }
}
