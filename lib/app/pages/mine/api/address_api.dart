import '../../../../network/network.dart';
import '../models/address_models.dart';
import '../models/address_tree_models.dart';

/// 地址相关 API
class AddressApi {
  /// 获取地址列表
  static Future<void> getAddressList({
    int page = 1,
    int limit = 12,
    void Function(UserAddressListEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserAddressListEntity>(
      '/api/app/address/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 删除地址
  static Future<void> deleteAddress({
    required String id,
    void Function(String? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<String>(
      '/api/app/address/del',
      data: {
        'id': id,
      },
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取地址详情
  static Future<void> getAddressDetail({
    required String id,
    void Function(UserAddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<UserAddressEntity>(
      '/api/app/address/detail/$id',
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 获取城市树
  static Future<void> getCityTree({
    void Function(List<AddressProvince>? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<List<AddressProvince>>(
      '/api/app/address/list/tree',
      showLoading: true,
      fromJsonT: (json) {
        final listData = json is List
            ? json
            : (json is Map ? json['data'] : null) as List<dynamic>?;
        if (listData == null) return <AddressProvince>[];
        return listData
            .whereType<Map>()
            .map((e) => AddressProvince.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// 保存地址
  static Future<void> saveAddress({
    required UserAddressEntity address,
    void Function(UserAddressEntity? data)? onSuccess,
    void Function(ApiException exception)? onError,
  }) {
    final addressJson = <String, dynamic>{
      'city': address.city ?? '',
      'district': address.district ?? '',
      'province': address.province ?? '',
    };
    if (address.cityId != null && address.cityId!.isNotEmpty) {
      addressJson['cityId'] = address.cityId;
    }
    final data = <String, dynamic>{
      'address': addressJson,
      'detail': address.detail ?? '',
      'isDefault': address.isDefault ?? true,
      'phone': address.phone ?? '',
      'realName': address.realName ?? '',
    };
    if (address.id != null && address.id!.isNotEmpty) {
      data['id'] = address.id;
    }
    return HttpClient.instance.post<UserAddressEntity>(
      '/api/app/address/edit',
      data: data,
      showLoading: true,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
