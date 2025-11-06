import 'package:dio/dio.dart';

class ApiExceptions implements Exception {
  final String message;

  ApiExceptions({required this.message});

  @override
  String toString() => message;

  factory ApiExceptions.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ApiExceptions(message: "Connection timeout with API Server");
      case DioExceptionType.sendTimeout:
        return ApiExceptions(message: "Send timeout with API Server");
      case DioExceptionType.receiveTimeout:
        return ApiExceptions(message: "Receive timeout with API Server");
      case DioExceptionType.badCertificate:
        return ApiExceptions(message: "Security certificate error");
      case DioExceptionType.badResponse:
        return ApiExceptions.fromResponse(
          dioException.response!.statusCode,
          dioException.response!.data,
        );
      case DioExceptionType.cancel:
        return ApiExceptions(message: "Request was cancelled");
      case DioExceptionType.connectionError:
        return ApiExceptions(message: "No Internet Connection");
      case DioExceptionType.unknown:
        return ApiExceptions(message: "Unexpected Error, Please try again!");
      default:
        return ApiExceptions(
          message: "Oops! There was an Error, Please Try Again",
        );
    }
  }

  factory ApiExceptions.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 ||
        statusCode == 401 ||
        statusCode == 403 ||
        statusCode == 404) {
      return ApiExceptions(
        message: response['message'] ?? 'Unauthorized access',
      );
    } else if (statusCode == 404) {
      return ApiExceptions(message: 'Request not found, Please try later!');
    } else if (statusCode == 500) {
      return ApiExceptions(message: 'Internal Server error, Please try later');
    } else if (statusCode == 422) {
      return ApiExceptions(message: response["message"] ?? 'Validation error');
    } else {
      return ApiExceptions(
        message: 'Oops! There was an Error, Please try again',
      );
    }
  }
}
