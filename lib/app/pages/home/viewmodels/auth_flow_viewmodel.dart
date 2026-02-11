import 'dart:io';

import 'package:flutter/foundation.dart';

import '../api/user_api.dart';
import '../models/auth_models.dart';

class AuthFlowViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _frontImageUrl;
  String? _backImageUrl;
  String? _realName;
  String? _idCard;
  String? _scoreImageUrl;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get frontImageUrl => _frontImageUrl;
  String? get backImageUrl => _backImageUrl;
  String? get realName => _realName;
  String? get idCard => _idCard;
  String? get scoreImageUrl => _scoreImageUrl;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<UploadIdCardEntity?> uploadIdCardImage({
    required File file,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    UploadIdCardEntity? result;
    await UserApi.uploadIdCardImage(
      filePath: file.path,
      onSuccess: (data) {
        result = data;
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );
    _setLoading(false);
    return result;
  }

  Future<String?> uploadScoreImage({
    required File file,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    String? imageUrl;
    await UserApi.uploadImage(
      filePath: file.path,
      onSuccess: (data) {
        imageUrl = data?.url;
        _scoreImageUrl = imageUrl;
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );
    _setLoading(false);
    notifyListeners();
    return imageUrl;
  }

  void updateFrontImage({
    required String? imageUrl,
    String? realName,
    String? idCard,
  }) {
    _frontImageUrl = imageUrl;
    _realName = realName ?? _realName;
    _idCard = idCard ?? _idCard;
    notifyListeners();
  }

  void updateBackImage({
    required String? imageUrl,
  }) {
    _backImageUrl = imageUrl;
    notifyListeners();
  }

  void updateManualIdentity({
    required String name,
    required String cardNo,
  }) {
    _realName = name;
    _idCard = cardNo;
    notifyListeners();
  }

  Future<bool> submitAuth() async {
    final name = (_realName ?? '').trim();
    final cardNo = (_idCard ?? '').trim();
    if (name.isEmpty || cardNo.isEmpty) {
      _errorMessage = '请先完成实名认证信息';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    bool verified = false;
    await UserApi.authIdCard(
      name: name,
      cardNo: cardNo,
      onSuccess: (data) {
        verified = data == true;
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );
    if (!verified) {
      _setLoading(false);
      notifyListeners();
      return false;
    }

    bool authSuccess = false;
    await UserApi.authRealName(
      data: {
        'name': name,
        'cardNo': cardNo,
        'cardFront': _frontImageUrl,
        'cardSide': _backImageUrl,
      },
      onSuccess: (data) {
        authSuccess = (data ?? '').isNotEmpty;
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );

    _setLoading(false);
    notifyListeners();
    return authSuccess;
  }

  Future<bool> submitMonthApply({
    required String companyName,
    required String position,
    required String residenceAddress,
    required String repaymentDate,
    required String billingDate,
    required String residentialLocationAddress,
    required String emergencyName1,
    required String emergencyNo1,
    required int emergencyRelation1,
    required String emergencyName2,
    required String emergencyNo2,
    required int emergencyRelation2,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    bool success = false;
    await UserApi.monthApply(
      data: {
        'aliPayImg': 'default',
        'aliScoreImg': _scoreImageUrl,
        'workLocation': 'default',
        'payPassword': 'default',
        'companyName': companyName,
        'position': position,
        'residenceAddress': residenceAddress,
        'repaymentDate': repaymentDate,
        'billingDate': billingDate,
        'residentialLocationAddress': residentialLocationAddress,
        'emergencyCount': '0',
        'emergencyName1': emergencyName1,
        'emergencyNo1': emergencyNo1,
        'emergencyRelation1': emergencyRelation1,
        'emergencyName2': emergencyName2,
        'emergencyNo2': emergencyNo2,
        'emergencyRelation2': emergencyRelation2,
      },
      onSuccess: (data) {
        success = data == true;
      },
      onError: (exception) {
        _errorMessage = exception.message;
      },
    );
    _setLoading(false);
    return success;
  }
}
