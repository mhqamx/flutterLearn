import 'package:dio/dio.dart';
import 'api_endpoint.dart';
import 'api_error.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  static NetworkManager get shared => _instance;

  late final Dio _dio;

  NetworkManager._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoint.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  Future<T> request<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request(
        path,
        options: Options(method: method),
        queryParameters: queryParameters,
        data: data,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return fromJson(response.data);
      } else {
        throw ApiException(
          ApiError.serverError,
          statusCode: response.statusCode,
          detail: '服务器返回 ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        ApiError.fromDioException(e),
        detail: e.message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(ApiError.unknown, detail: e.toString());
    }
  }

  Future<T> requestWithRetry<T>(
    String path, {
    required T Function(dynamic json) fromJson,
    int maxRetries = 3,
  }) async {
    ApiException? lastError;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await request(path, fromJson: fromJson);
      } on ApiException catch (e) {
        lastError = e;
        if (!e.error.isRetryable || attempt == maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << (attempt - 1)));
      }
    }
    throw lastError ?? ApiException(ApiError.unknown);
  }
}
