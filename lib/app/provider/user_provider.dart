import 'package:flutter_test_demo/app/utils/device_utils.dart';
import 'package:flutter_test_demo/app/utils/shared_preferences_util.dart';
import 'package:flutter_test_demo/app/utils/string_utils.dart';

class UserProvider {
  static const String _protocolAgreementKey = 'has_agreed_protocol';
  static const String _oaidKey = 'user_oaid';
  static const String _idfaKey = 'user_idfa';
  static const String _lastIpKey = 'user_lastIp';
  static const String _inviteCodeKey = 'user_inviteCode';
  static const String _userTokenKey = 'user_token';
  static const String _userNickNameKey = 'user_nick_name';
  static const String _userPhoneKey = 'user_phone';
  static const String _userAvatarKey = 'user_avatar';
  static const String _userMoneyKey = 'user_money';

  static String? _oaid = "";
  static String? _idfa = "";
  static String? _lastIp = "";
  static String? _inviteCode = "";
  static String? _userToken = "";
  static String? _deviceModel = "";
  static String? _userNickName = "";
  static String? _userPhone = "";
  static String? _userAvatar = "";
  static String? _userMoney = "";

  static Future<void> updateUserInfo() async {
    _oaid = await SharedPreferencesUtil.getString(_oaidKey);
    _idfa = await SharedPreferencesUtil.getString(_idfaKey);
    _deviceModel =
        await SharedPreferencesUtil.getString(DeviceUtils.deviceModelKey);
    _userToken = await SharedPreferencesUtil.getString(_userTokenKey);
    _lastIp = await SharedPreferencesUtil.getString(_lastIpKey);
    _inviteCode = await SharedPreferencesUtil.getString(_inviteCodeKey);

    _userNickName = await SharedPreferencesUtil.getString(_userNickNameKey);
    _userPhone = await SharedPreferencesUtil.getString(_userPhoneKey);
    _userAvatar = await SharedPreferencesUtil.getString(_userAvatarKey);
    _userMoney = await SharedPreferencesUtil.getString(_userMoneyKey);
  }

  /// 设置用户协议同意状态
  static Future<void> setProtocolAgreed(bool agreed) async {
    await SharedPreferencesUtil.setBool(_protocolAgreementKey, agreed);
  }

  /// 获取用户协议同意状态
  static Future<bool> getProtocolAgreed() async {
    final prefs = await SharedPreferencesUtil.getBool(_protocolAgreementKey);
    return prefs;
  }

  /// 移除用户协议同意状态
  static Future<void> removeProtocolAgreed() async {
    await SharedPreferencesUtil.remove(_protocolAgreementKey);
    updateUserInfo();
  }

  /// 存储OAID (设备标识符)
  /// 对应Android
  static Future<void> setOaid(String? oaid) async {
    if (oaid != null && oaid.isNotEmpty) {
      await SharedPreferencesUtil.setString(_oaidKey, oaid);
    } else {
      await SharedPreferencesUtil.remove(_oaidKey);
    }
    updateUserInfo();
  }

  /// 存储IDFA (设备标识符)
  /// 对应IOS
  static Future<void> setIdfa(String? idfa) async {
    if (idfa != null && idfa.isNotEmpty) {
      await SharedPreferencesUtil.setString(_idfaKey, idfa);
    } else {
      await SharedPreferencesUtil.remove(_idfaKey);
    }
    updateUserInfo();
  }



  /// 存储昵称
  static Future<void> setUserNickName(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_userNickNameKey, content);
    } else {
      await SharedPreferencesUtil.remove(_userNickNameKey);
    }
    updateUserInfo();
  }

  /// 存储手机号
  static Future<void> setUserPhone(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_userPhoneKey, content);
    } else {
      await SharedPreferencesUtil.remove(_userPhoneKey);
    }
    updateUserInfo();
  }

  /// 存储头像
  static Future<void> setUserAvatar(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_userAvatarKey, content);
    } else {
      await SharedPreferencesUtil.remove(_userAvatarKey);
    }
    updateUserInfo();
  }

  /// 存储用户余额
  static Future<void> setUserMoney(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_userMoneyKey, content);
    } else {
      await SharedPreferencesUtil.remove(_userMoneyKey);
    }
    updateUserInfo();
  }

  /// 存储设备型号信息
  /// 对应Android: jsonObject.put("deviceModel", StringUtils.getStringBuilder().append(Build.MODEL).append(Build.MANUFACTURER).append(Build.VERSION.RELEASE).toString())
  static Future<void> setDeviceModel(String deviceModel) async {
    if (deviceModel.isNotEmpty) {
      await SharedPreferencesUtil.setString(
          DeviceUtils.deviceModelKey, deviceModel);
      updateUserInfo();
    }
  }

  /// 存储最后一次ip
  static Future<void> setLastIp(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_lastIpKey, content);
    } else {
      await SharedPreferencesUtil.remove(_lastIpKey);
    }
    updateUserInfo();
  }

  /// 存储token
  static Future<void> setUserToken(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_userTokenKey, content);
    } else {
      await SharedPreferencesUtil.remove(_userTokenKey);
    }
    updateUserInfo();
  }

  /// 存储邀请码
  static Future<void> setInviteCode(String? content) async {
    if (content != null && content.isNotEmpty) {
      await SharedPreferencesUtil.setString(_inviteCodeKey, content);
    } else {
      await SharedPreferencesUtil.remove(_inviteCodeKey);
    }
    updateUserInfo();
  }

  /// 获取OAID (设备标识符)
  static String getOaid() {
    return StringUtils.getNotNullParam(_oaid);
  }

  /// 获取Token
  static String getUserToken() {
    return StringUtils.getNotNullParam(_userToken);
  }


  /// 是否登录
  static bool isLogin() {
    return !StringUtils.isEmpty(_userToken);
  }

  /// 获取昵称
  static String getUserNickName() {
    return StringUtils.getNotNullParam(_userNickName);
  }

  /// 获取手机号
  static String getUserPhone() {
    return StringUtils.getNotNullParam(_userPhone);
  }

  /// 获取头像
  static String getUserAvatar() {
    return StringUtils.getNotNullParam(_userAvatar);
  }

  /// 获取用户余额
  static String getUserMoney() {
    return StringUtils.getNotNullParam(_userMoney);
  }

  /// 获取IDFA (设备标识符)
  static String getIdfa() {
    return StringUtils.getNotNullParam(_idfa);
  }

  /// 获取最后一次Ip
  static String getLastIp() {
    return StringUtils.getNotNullParam(_lastIp);
  }

  /// 获取邀请码
  static String getInviteCode() {
    return StringUtils.getNotNullParam(_inviteCode);
  }

  /// 获取DeviceModel (设备标识符)
  static String getDeviceModel() {
    return StringUtils.getNotNullParam(_deviceModel);
  }


  /// 清空用户信息
  static Future<void> clearUserInfo() async {
    await SharedPreferencesUtil.remove(_userTokenKey);
    await SharedPreferencesUtil.remove(_userPhoneKey);
    await SharedPreferencesUtil.remove(_userNickNameKey);
    await SharedPreferencesUtil.remove(_userAvatarKey);
    await SharedPreferencesUtil.remove(_userMoneyKey);
    _userToken = "";
    _userPhone = "";
    _userNickName = "";
    _userAvatar = "";
    _userMoney = "";
    updateUserInfo();
  }


  /// 移除OAID
  static Future<void> removeOaid() async {
    await SharedPreferencesUtil.remove(_oaidKey);
    updateUserInfo();
  }

  /// 移除设备型号信息
  static Future<void> removeDeviceModel() async {
    await SharedPreferencesUtil.remove(DeviceUtils.deviceModelKey);
    updateUserInfo();
  }
}
