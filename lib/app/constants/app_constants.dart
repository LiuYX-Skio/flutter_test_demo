/// 应用常量
class AppConstants {
  const AppConstants._();

  static const String baseUrl = 'http://appbysc.xinjiuyou.xyz';

  /// 启动页倒计时时长（秒）
  static const int splashCountdownTime = 3;

  /// 延迟时间（毫秒）
  static const int delayTime = 1000;

  static const String channelCode = "byscxiaomi"; ///渠道号

  static const int AUTH_LOGIN_CODE = 401; ///渠道号


  /// 用户协议URL - 使用HTTPS版本，需要SSL配置生效
  static const String userProtocolUrl = 'https://xinjiuyou.xyz/bysczc.html';

  /// 注册协议URL
  static const String userRegisterProtocolUrl = 'https://xinjiuyou.xyz/bysczc.html';

  /// 隐私协议URL - 使用HTTPS版本，需要SSL配置生效
  static const String privacyProtocolUrl = 'http://www.xinjiuyou.xyz/byscys.html';

  /// 个人隐私共享清单
  static const String userPrivacyShareProtocolUrl = 'https://www.xinjiuyou.xyz/byscgxqd.html';

  /// 个人隐私收集清单
  static const String userPrivacyGatherProtocolUrl = 'http://www.xinjiuyou.xyz/byscgxqd.html';

  /// 备案信息
  static const String userRemarkProtocolUrl = 'https://beian.miit.gov.cn';

  /// 黄金回收协议
  static const String userRecycleGoldProtocolUrl =
      'https://xinjiuyou.xyz/byschsxy.html';

  /// 手机回收协议
  static const String userRecyclePhoneProtocolUrl =
      'https://xinjiuyou.xyz/byschsxy.html';

  /// 用户协议标题
  static const String userProtocolTitle = '用户协议';
  /// 隐私协议标题
  static const String privacyProtocolTitle = '隐私协议';
  /// 注册协议标题
  static const String registerProtocolTitle = '注册协议';
  /// 个人隐私共享清单标题
  static const String privacyShareTitle = '个人隐私共享清单';
  /// 个人隐私收集清单标题
  static const String privacyGatherTitle = '个人隐私收集清单';
  /// 备案标题
  static const String remarkProtocolTitle = 'ICP/IP地址/域名信息备案管理系统';
}
