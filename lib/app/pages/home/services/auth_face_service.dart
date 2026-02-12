import '../../../../app/provider/user_provider.dart';
import '../api/user_api.dart';
import '../models/auth_models.dart';
import 'face_verify_bridge.dart';

class AuthSubmissionResult {
  final bool success;
  final String? message;

  const AuthSubmissionResult({
    required this.success,
    this.message,
  });
}

class AuthFaceService {
  Future<bool> hasAuthentication() async {
    var hasAuthentication = false;
    await UserApi.getUserInfo(
      onSuccess: (data) {
        hasAuthentication = data?.hasAuthentication == true;
      },
      onError: (_) {},
    );
    return hasAuthentication;
  }

  Future<UploadIdCardEntity?> uploadIdCardImage({
    required String filePath,
    required bool isFront,
  }) async {
    UploadIdCardEntity? result;
    if (isFront) {
      await UserApi.uploadIdCardImage(
        filePath: filePath,
        onSuccess: (data) => result = data,
        onError: (_) {},
      );
      return result;
    }

    await UserApi.uploadImage(
      filePath: filePath,
      showLoading: true,
      onSuccess: (data) {
        result = UploadIdCardEntity(url: data?.url);
      },
      onError: (_) {},
    );
    return result;
  }

  Future<AuthSubmissionResult> submitAuth({
    required String realName,
    required String idCard,
    required String? frontImageUrl,
    required String? backImageUrl,
    required bool needMetaVerify,
  }) async {
    if (realName.trim().isEmpty || idCard.trim().isEmpty) {
      return const AuthSubmissionResult(success: false, message: '请先完成实名认证信息');
    }

    String? errorMessage;
    if (needMetaVerify) {
      var verified = false;
      await UserApi.authIdCard(
        name: realName,
        cardNo: idCard,
        onSuccess: (data) => verified = data == true,
        onError: (exception) => errorMessage = exception.message,
      );
      if (!verified) {
        return AuthSubmissionResult(
          success: false,
          message: errorMessage ?? '身份证校验失败',
        );
      }
    }

    final metaInfo = await FaceVerifyBridge.getMetaInfo();
    String? certifyId;
    await UserApi.authRealName(
      data: {
        'name': realName,
        'cardNo': idCard,
        'cardFront': frontImageUrl,
        'cardSide': backImageUrl,
        if ((metaInfo ?? '').isNotEmpty) 'metaInfo': metaInfo,
      },
      onSuccess: (data) => certifyId = data,
      onError: (exception) => errorMessage = exception.message,
    );
    if ((certifyId ?? '').isEmpty) {
      return AuthSubmissionResult(
        success: false,
        message: errorMessage ?? '实名认证初始化失败',
      );
    }

    final verifyResult = await FaceVerifyBridge.verify(
      certifyId: certifyId!,
      useVideo: false,
    );
    if (!verifyResult.success) {
      return AuthSubmissionResult(
        success: false,
        message: '认证失败：${verifyResult.reason ?? '请重试'}',
      );
    }

    var faceResultSuccess = false;
    await UserApi.faceResult(
      onSuccess: (data) => faceResultSuccess = (data ?? '').isNotEmpty,
      onError: (exception) => errorMessage = exception.message,
    );
    if (!faceResultSuccess) {
      return AuthSubmissionResult(
        success: false,
        message: errorMessage ?? '认证失败，请重试',
      );
    }

    await _refreshUserCache();
    return const AuthSubmissionResult(success: true);
  }

  Future<void> _refreshUserCache() async {
    await UserApi.getUserInfo(
      onSuccess: (data) async {
        await UserProvider.setUserNickName(data?.nickname);
        await UserProvider.setUserPhone(data?.phone);
        await UserProvider.setUserAvatar(data?.avatar);
      },
      onError: (_) {},
    );
  }
}
