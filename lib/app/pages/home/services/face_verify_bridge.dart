import 'package:flutter/services.dart';

class FaceVerifyResult {
  final bool success;
  final int code;
  final String? reason;

  const FaceVerifyResult({
    required this.success,
    required this.code,
    this.reason,
  });
}

class FaceVerifyBridge {
  FaceVerifyBridge._();

  static const MethodChannel _channel =
      MethodChannel('com.example.flutter_test_demo/face_verify');

  static Future<String?> getMetaInfo() async {
    try {
      final result = await _channel.invokeMethod<dynamic>('getMetaInfo');
      return result?.toString();
    } catch (_) {
      return null;
    }
  }

  static Future<FaceVerifyResult> verify({
    required String certifyId,
    bool useVideo = false,
  }) async {
    try {
      final result = await _channel.invokeMethod<dynamic>(
        'startFaceVerify',
        <String, dynamic>{
          'certifyId': certifyId,
          'useVideo': useVideo,
        },
      );
      if (result is Map) {
        final code = (result['code'] as num?)?.toInt() ?? -1;
        final success = result['success'] == true || code == 1000;
        return FaceVerifyResult(
          success: success,
          code: code,
          reason: result['reason']?.toString(),
        );
      }
      return const FaceVerifyResult(
        success: false,
        code: -1,
        reason: '人脸识别结果异常',
      );
    } on PlatformException catch (e) {
      return FaceVerifyResult(
        success: false,
        code: -1,
        reason: e.message ?? '人脸识别调用失败',
      );
    } catch (_) {
      return const FaceVerifyResult(
        success: false,
        code: -1,
        reason: '人脸识别调用失败',
      );
    }
  }
}
