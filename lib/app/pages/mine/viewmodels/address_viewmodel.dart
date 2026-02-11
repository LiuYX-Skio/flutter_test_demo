import 'package:flutter/material.dart';
import '../api/address_api.dart';
import '../models/address_models.dart';
import '../models/address_tree_models.dart';

class AddressViewModel extends ChangeNotifier {
  List<UserAddressEntity> _addresses = [];
  List<AddressProvince> _cityTree = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserAddressEntity> get addresses => _addresses;
  List<AddressProvince> get cityTree => _cityTree;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAddressList({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    await AddressApi.getAddressList(
      page: page,
      onSuccess: (data) {
        _addresses = data?.list ?? [];
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '获取地址失败';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> deleteAddress(String id) async {
    await AddressApi.deleteAddress(
      id: id,
      onSuccess: (_) {
        _addresses.removeWhere((element) => element.id == id);
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = '删除地址失败';
        notifyListeners();
      },
    );
  }

  Future<void> fetchAddressDetail({
    required String id,
    required void Function(UserAddressEntity? data) onSuccess,
  }) async {
    await AddressApi.getAddressDetail(
      id: id,
      onSuccess: onSuccess,
      onError: (exception) {
        _errorMessage = '获取地址详情失败';
        notifyListeners();
      },
    );
  }

  Future<void> fetchCityTree({
    required void Function(List<AddressProvince> list) onSuccess,
  }) async {
    await AddressApi.getCityTree(
      onSuccess: (data) {
        _cityTree = data ?? [];
        onSuccess(_cityTree);
      },
      onError: (exception) {
        _errorMessage = '获取城市列表失败';
        notifyListeners();
      },
    );
  }

  Future<void> saveAddress({
    required UserAddressEntity address,
    required void Function(UserAddressEntity? data) onSuccess,
  }) async {
    await AddressApi.saveAddress(
      address: address,
      onSuccess: onSuccess,
      onError: (exception) {
        _errorMessage = '保存地址失败';
        notifyListeners();
      },
    );
  }
}
