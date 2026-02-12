import '../../../../network/network.dart';
import '../../../../app/provider/user_provider.dart';
import '../models/user_models.dart';
import '../models/address_models.dart';
import '../models/auth_models.dart';
import '../../mine/models/mine_models.dart';

/// 用户 API 接口
class UserApi {
  /// 获取用户信息
  static Future<void> getUserInfo({
    void Function(UserInfoEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserInfoEntity>(
      '/api/app/user/user',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取默认地址
  static Future<void> getDefaultAddress({
    void Function(AddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<AddressEntity>(
      '/api/app/address/default',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取用户信用详情
  static Future<void> getUserCreditDetail({
    void Function(UserCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserCreditEntity>(
      '/api/app/user-credit/user-credit',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取我的额度
  static Future<void> getMyCreditLimit({
    void Function(MyCreditEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<MyCreditEntity>(
      '/api/app/user-credit/my-credit',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 退出登录
  static Future<void> loginOut({
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/user/logout',
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 注销账号
  static Future<void> cancelAccount({
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/user/writeOff',
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 修改用户资料
  static Future<void> updateUserInfo({
    String? avatar,
    String? nickname,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final data = <String, dynamic>{};
    if (avatar != null && avatar.isNotEmpty) {
      data['avatar'] = avatar;
    }
    if (nickname != null && nickname.isNotEmpty) {
      data['nickname'] = nickname;
    }
    return HttpClient.instance.post<String>(
      '/api/app/user/user/edit',
      data: data,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 上传头像图片
  static Future<void> uploadImage({
    required String filePath,
    bool showLoading = false,
    void Function(UploadEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.upload<UploadEntity>(
      '/api/app/user/upload/image',
      filePath,
      data: {'model': 'user'},
      showLoading: showLoading,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 身份证图片上传
  static Future<void> uploadIdCardImage({
    required String filePath,
    void Function(UploadIdCardEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.upload<UploadIdCardEntity>(
      '/api/app/user/upload/id-card-upload',
      filePath,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 身份证实名认证校验
  static Future<void> authIdCard({
    required String name,
    required String cardNo,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<bool>(
      '/api/app/user/meta-verify',
      data: {
        'name': name,
        'cardNo': cardNo,
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 实名认证
  static Future<void> authRealName({
    required Map<String, dynamic> data,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/user/user-authentication',
      data: data,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取人脸识别结果
  static Future<void> faceResult({
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/user/face-recognition-result',
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 发起月付申请
  static Future<void> monthApply({
    required Map<String, dynamic> data,
    void Function(bool? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<bool>(
      '/api/app/user-credit/apply-credit',
      data: data,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 更新地址信息（用于定位上报）
  static Future<void> updateAddress({
    required String address,
    void Function(dynamic data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<dynamic>(
      '/api/app/user/user/edit',
      data: {
        'address': address,
        'oaid': UserProvider.getOaid(),
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
