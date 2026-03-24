import 'package:dio/dio.dart';

enum ApiError {
  invalidUrl('无效的URL'),
  noData('没有数据'),
  decodingFailed('数据解析失败'),
  serverError('服务器错误'),
  networkUnavailable('网络不可用'),
  timeout('请求超时'),
  unknown('未知错误');

  final String message;
  const ApiError(this.message);

  bool get isRetryable =>
      this == ApiError.networkUnavailable ||
      this == ApiError.timeout ||
      this == ApiError.serverError;

  static ApiError fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError.timeout;
      case DioExceptionType.connectionError:
        return ApiError.networkUnavailable;
      case DioExceptionType.badResponse:
        return ApiError.serverError;
      default:
        return ApiError.unknown;
    }
  }
}

class ApiException implements Exception {
  final ApiError error;
  final String? detail;
  final int? statusCode;

  ApiException(this.error, {this.detail, this.statusCode});

  String get message => detail ?? error.message;

  @override
  String toString() => 'ApiException: ${error.name} - $message';
}
