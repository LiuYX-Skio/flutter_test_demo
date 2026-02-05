import 'package:dio/dio.dart';
import '../api_exception.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  /// 全局错误处理回调
  final void Function(ApiException exception)? errorHandler;

  ErrorInterceptor({this.errorHandler});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 将 DioException 转换为 ApiException
    final apiException = ApiException.fromDioException(err);

    // 触发全局错误回调
    errorHandler?.call(apiException);

    super.onError(err, handler);
  }
}
