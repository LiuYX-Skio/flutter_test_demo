import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'http_config.dart';
import 'json_converter_registry.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/log_interceptor.dart' as custom;

/// HTTP 客户端（单例）
class HttpClient {
  static HttpClient? _instance;
  late Dio _dio;
  HttpConfig? _config;

  /// 获取单例
  static HttpClient get instance {
    _instance ??= HttpClient._internal();
    return _instance!;
  }

  HttpClient._internal();

  /// 初始化配置
  void init(HttpConfig config) {
    _config = config;
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(milliseconds: config.connectTimeout),
        receiveTimeout: Duration(milliseconds: config.receiveTimeout),
        sendTimeout: Duration(milliseconds: config.sendTimeout),
        headers: config.headers,
        contentType: config.contentType,
      ),
    );

    // 添加日志拦截器
    if (config.enableLog) {
      _dio.interceptors.add(custom.LogInterceptor(enabled: true));
    }
  }

  /// 添加认证拦截器
  void addAuthInterceptor({
    Future<String?> Function()? onGetToken,
    Future<String?> Function()? onRefreshToken,
    void Function()? onUnauthorized,
  }) {
    _dio.interceptors.add(
      AuthInterceptor(
        onGetToken: onGetToken,
        onRefreshToken: onRefreshToken,
        onUnauthorized: onUnauthorized,
      ),
    );
  }

  /// 添加错误拦截器
  void addErrorInterceptor({
    void Function(ApiException exception)? onError,
  }) {
    _dio.interceptors.add(
      ErrorInterceptor(errorHandler: onError),
    );
  }

  /// 添加自定义拦截器
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// 获取 Dio 实例（用于高级用法）
  Dio get dio => _dio;

  /// 通用请求方法
  Future<T> _request<T>(String path, {
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method).copyWith(
          headers: options?.headers,
          contentType: options?.contentType,
          responseType: options?.responseType,
        ),
        cancelToken: cancelToken,
      );

      // 如果响应数据是 Map，尝试解析为 ApiResponse
      if (response.data is Map<String, dynamic>) {
        // 优先使用传入的 fromJsonT，否则从注册表获取
        final converter = fromJsonT ?? JsonConverterRegistry().getConverter<T>();

        final apiResponse = ApiResponse<T>.fromJson(
          response.data as Map<String, dynamic>,
          fromJsonT: converter,
        );

        // 检查业务状态码
        if (!apiResponse.isSuccess) {
          throw ApiException.business(
            code: apiResponse.code,
            message: apiResponse.message,
          );
        }

        return apiResponse.data as T;
      }

      // 直接返回数据
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// GET 请求
  Future<T> get<T>(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// POST 请求
  Future<T> post<T>(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// PUT 请求
  Future<T> put<T>(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// DELETE 请求
  Future<T> delete<T>(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// PATCH 请求
  Future<T> patch<T>(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
    );
  }

  /// 上传文件
  Future<T> upload<T>(
    String path,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        ...?data,
      });

      final response = await _dio.post(
        path,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      // 如果响应数据是 Map，尝试解析为 ApiResponse
      if (response.data is Map<String, dynamic>) {
        // 优先使用传入的 fromJsonT，否则从注册表获取
        final converter = fromJsonT ?? JsonConverterRegistry().getConverter<T>();

        final apiResponse = ApiResponse<T>.fromJson(
          response.data as Map<String, dynamic>,
          fromJsonT: converter,
        );

        // 检查业务状态码
        if (!apiResponse.isSuccess) {
          throw ApiException.business(
            code: apiResponse.code,
            message: apiResponse.message,
          );
        }

        return apiResponse.data as T;
      }

      // 直接返回数据
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(
        type: ApiExceptionType.unknown,
        message: e.toString(),
        originalError: e,
      );
    }
  }

  /// 下载文件
  Future<void> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}