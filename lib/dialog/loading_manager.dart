import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 加载弹窗管理器（单例）
/// 用于统一管理应用中的加载弹窗，避免内存泄露
class LoadingManager {
  LoadingManager._();

  static final LoadingManager _instance = LoadingManager._();

  /// 获取单例实例
  static LoadingManager get instance => _instance;

  /// 是否正在显示加载弹窗
  bool _isShowing = false;

  /// 显示加载弹窗
  /// [status] 加载提示文本，默认为"加载中..."
  /// [maskType] 遮罩类型，默认为黑色半透明遮罩
  Future<void> show({
    String status = '加载中...',
    EasyLoadingMaskType maskType = EasyLoadingMaskType.black,
  }) async {
    if (_isShowing) {
      return;
    }
    _isShowing = true;
    await EasyLoading.show(
      status: status,
      maskType: maskType,
    );
  }

  /// 关闭加载弹窗
  Future<void> dismiss() async {
    if (!_isShowing) {
      return;
    }
    _isShowing = false;
    await EasyLoading.dismiss();
  }

  /// 显示成功提示
  /// [message] 提示文本
  /// [duration] 显示时长，默认2秒
  Future<void> showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    await EasyLoading.showSuccess(
      message,
      duration: duration,
      maskType: EasyLoadingMaskType.black,
    );
  }

  /// 显示错误提示
  /// [message] 提示文本
  /// [duration] 显示时长，默认2秒
  Future<void> showError(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    await EasyLoading.showError(
      message,
      duration: duration,
      maskType: EasyLoadingMaskType.black,
    );
  }

  /// 显示信息提示
  /// [message] 提示文本
  /// [duration] 显示时长，默认2秒
  Future<void> showInfo(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    await EasyLoading.showInfo(
      message,
      duration: duration,
      maskType: EasyLoadingMaskType.black,
    );
  }

  /// 显示警告提示
  /// [message] 提示文本
  /// [duration] 显示时长，默认2秒
  Future<void> showWarning(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    await EasyLoading.showToast(
      message,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.center,
      maskType: EasyLoadingMaskType.black,
    );
  }
}
