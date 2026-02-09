import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test_demo/app/provider/user_provider.dart';
import 'package:flutter_test_demo/app/utils/shared_preferences_util.dart';

class DeviceUtils {

  static const String deviceModelKey = 'user_device_model';

  /// 获取或生成设备型号信息 (如果没有存储则实时获取)
  /// 对应Android的Build.MODEL + Build.MANUFACTURER + Build.VERSION.RELEASE格式
  static Future<String> getOrCreateDeviceModel() async {
    // 先尝试从本地存储获取
    String? storedModel = await SharedPreferencesUtil.getString(deviceModelKey);
    if (storedModel != null && storedModel.isNotEmpty) {
      return storedModel;
    }

    // 如果没有存储，则实时获取设备信息
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel =
            '${androidInfo.model} ${androidInfo.manufacturer} ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = '${iosInfo.utsname.machine} ${iosInfo.systemVersion}';
      } else {
        deviceModel = 'Unknown Device';
      }

      // 存储到本地
      await UserProvider.setDeviceModel(deviceModel);
      return deviceModel;
    } catch (e) {
      print('获取设备型号失败: $e');
      return "";
    }
  }
}
