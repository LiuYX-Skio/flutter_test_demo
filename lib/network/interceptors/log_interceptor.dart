import 'package:dio/dio.dart';

/// 日志拦截器
class LogInterceptor extends Interceptor {
  final bool enabled;

  LogInterceptor({this.enabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      print('╔════════════════════════════════════════════════════════════════');
      print('║ 📤 REQUEST');
      print('║ URL: ${options.uri}');
      print('║ Method: ${options.method}');
      print('║ Headers: ${options.headers}');
      if (options.data != null) {
        print('║ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('║ Query: ${options.queryParameters}');
      }
      print('╚════════════════════════════════════════════════════════════════');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      print('╔════════════════════════════════════════════════════════════════');
      print('║ 📥 RESPONSE');
      print('║ URL: ${response.requestOptions.uri}');
      print('║ Status: ${response.statusCode}');
      print('║ Data: ${response.data}');
      print('╚════════════════════════════════════════════════════════════════');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      print('╔════════════════════════════════════════════════════════════════');
      print('║ ❌ ERROR');
      print('║ URL: ${err.requestOptions.uri}');
      print('║ Type: ${err.type}');
      print('║ Message: ${err.message}');
      if (err.response != null) {
        print('║ Status: ${err.response?.statusCode}');
        print('║ Data: ${err.response?.data}');
      }
      print('╚════════════════════════════════════════════════════════════════');
    }
    super.onError(err, handler);
  }
}
