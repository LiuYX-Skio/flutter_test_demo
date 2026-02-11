import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test_demo/app/constants/app_constants.dart';
import 'package:flutter_test_demo/app/dialog/loading_manager.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:flutter_test_demo/navigation/core/route_paths.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'http_config.dart';
import 'json_converter_registry.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/log_interceptor.dart' as custom;

/// HTTP 客户端（单例）
class HttpClient {
  static HttpClient? _instance;
  late Dio _dio;

  /// 获取单例
  static HttpClient get instance {
    _instance ??= HttpClient._internal();
    return _instance!;
  }

  HttpClient._internal();

  /// 初始化配置
  void init(HttpConfig config) {
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
      // 设置代理
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      //   client.findProxy = (uri) {
      //     // 走本机 8888 端口（比如 Charles / Fiddler）
      //     return "PROXY 192.168.1.112:8989";
      //   };
      //
      //   // 如果抓包时 HTTPS 证书不合法，可以忽略
      //   client.badCertificateCallback = (cert, host, port) => true;
      //
      //   return client;
      // };
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

  /// 添加自定义拦截器
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// 获取 Dio 实例（用于高级用法）
  Dio get dio => _dio;

  /// 通用请求方法
  Future<T?> _request<T>(
    String path, {
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) async {
    // 显示加载弹窗
    if (showLoading) {
      LoadingManager.instance.show();
    }

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
        final converter =
            fromJsonT ?? JsonConverterRegistry().getConverter<T>();
        final apiResponse = ApiResponse<T>.fromJson(
          response.data as Map<String, dynamic>,
          fromJsonT: converter,
        );

        // 检查业务状态码
        if (!apiResponse.isSuccess) {
          final exception = ApiException.business(
            code: apiResponse.code,
            message: apiResponse.message,
          );
          if (onError != null) {
            onError(exception);
          }
          print("data: failed :${apiResponse.message}");
          return null;
        }

        if (onSuccess != null) {
          print("data finally: ${apiResponse.message},${apiResponse.code}");
          onSuccess(apiResponse.data);
        }
        return apiResponse.data;
      }

      // 如果响应数据是 List，直接处理
      if (response.data is List) {
        T? result;
        if (fromJsonT != null) {
          result = fromJsonT(response.data);
        } else {
          result = JsonConverterRegistry().convert<T>(response.data);
        }
        if (onSuccess != null) {
          print("data: null");
          onSuccess(result);
        }
        return result;
      }

      // 其他类型直接返回
      if (onSuccess != null) {
        onSuccess(null);
      }
      return null;
    } on DioException catch (e) {
      final exception = ApiException.fromDioException(e);
      if (onError != null) {
        onError(exception);
      }
      return null;
    } catch (e) {
      final exception = ApiException(
        type: ApiExceptionType.unknown,
        message: e.toString(),
        originalError: e,
      );
      if (onError != null) {
        onError(exception);
      }
      return null;
    } finally {
      // 关闭加载弹窗
      if (showLoading) {
        LoadingManager.instance.dismiss();
      }
    }
  }

  /// GET 请求
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// POST 请求
  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// PUT 请求
  Future<T?> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// DELETE 请求
  Future<T?> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// PATCH 请求
  Future<T?> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
    bool showLoading = false,
  }) {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJsonT: fromJsonT,
      onSuccess: onSuccess,
      onError: onError,
      showLoading: showLoading,
    );
  }

  /// 上传文件
  Future<T?> upload<T>(
    String path,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJsonT,
    void Function(T? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
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
        final converter =
            fromJsonT ?? JsonConverterRegistry().getConverter<T>();
        final apiResponse = ApiResponse<T>.fromJson(
          response.data as Map<String, dynamic>,
          fromJsonT: converter,
        );

        // 检查业务状态码
        if (!apiResponse.isSuccess) {
          final exception = ApiException.business(
            code: apiResponse.code,
            message: apiResponse.message,
          );
          if (onError != null) {
            onError(exception);
          }
          return null;
        }

        if (onSuccess != null) {
          onSuccess(apiResponse.data);
        }
        return apiResponse.data;
      }

      // 如果响应数据是 List，直接处理
      if (response.data is List) {
        T? result;
        if (fromJsonT != null) {
          result = fromJsonT(response.data);
        } else {
          result = JsonConverterRegistry().convert<T>(response.data);
        }
        if (onSuccess != null) {
          onSuccess(result);
        }
        return result;
      }

      // 其他类型直接返回
      final result = response.data as T?;
      if (onSuccess != null) {
        onSuccess(result);
      }
      return result;
    } on DioException catch (e) {
      final exception = ApiException.fromDioException(e);
      if (onError != null) {
        onError(exception);
      }
      return null;
    } catch (e) {
      final exception = ApiException(
        type: ApiExceptionType.unknown,
        message: e.toString(),
        originalError: e,
      );
      if (onError != null) {
        onError(exception);
      }
      return null;
    }
  }

  /// 下载文件
  Future<void> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    void Function(ApiException exception)? onError,
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
      final exception = ApiException.fromDioException(e);
      if (onError != null) {
        onError(exception);
      }
    }
  }
}
