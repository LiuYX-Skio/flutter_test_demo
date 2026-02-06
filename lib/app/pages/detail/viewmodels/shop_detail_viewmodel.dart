import 'package:flutter/material.dart';
import '../models/shop_detail_models.dart';
import '../api/shop_detail_api.dart';
import '../../home/models/product_models.dart';
import '../../home/models/address_models.dart';

/// 商品详情 ViewModel
/// 管理商品详情页面的数据和业务逻辑
class ShopDetailViewModel extends ChangeNotifier {
  // 商品详情数据
  ShopDetailEntity? _shopDetail;

  // 评论列表数据
  ShopCommentOutEntity? _commentList;

  // 默认地址数据
  AddressEntity? _defaultAddress;

  // 推荐商品列表
  ShopOutEntity? _recommendList;

  // 购物车数量
  int _cartCount = 0;

  // 加载状态
  bool _isLoading = false;
  bool _isLoadingComment = false;
  bool _isLoadingAddress = false;
  bool _isLoadingRecommend = false;

  // 错误信息
  String? _errorMessage;

  // 当前选中的商品属性ID
  String? _selectedAttrId;

  // 当前选中的SKU
  String? _selectedSku;

  // 购物车ID
  String? _cartId;

  // Getters
  ShopDetailEntity? get shopDetail => _shopDetail;
  ShopCommentOutEntity? get commentList => _commentList;
  AddressEntity? get defaultAddress => _defaultAddress;
  ShopOutEntity? get recommendList => _recommendList;
  int get cartCount => _cartCount;
  bool get isLoading => _isLoading;
  bool get isLoadingComment => _isLoadingComment;
  bool get isLoadingAddress => _isLoadingAddress;
  bool get isLoadingRecommend => _isLoadingRecommend;
  String? get errorMessage => _errorMessage;
  String? get selectedAttrId => _selectedAttrId;
  String? get selectedSku => _selectedSku;
  String? get cartId => _cartId;

  /// 获取商品详情
  Future<void> fetchShopDetail(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 并行请求商品详情和购物车数量
      await Future.wait([
        _getShopDetail(id),
        _getCartCount(),
      ]);

      // 设置默认选中的属性
      if (_shopDetail?.productValueList != null &&
          _shopDetail!.productValueList!.isNotEmpty) {
        _selectedAttrId = _shopDetail!.productValueList![0].id?.toString();
      }
    } catch (e) {
      _errorMessage = '获取商品详情失败';
      debugPrint('fetchShopDetail error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取商品详情（内部方法）
  Future<void> _getShopDetail(int id) async {
    await ShopDetailApi.getShopDetail(
      id: id,
      onSuccess: (data) {
        _shopDetail = data;
      },
      onError: (exception) {
        _errorMessage = exception.message;
        debugPrint('getShopDetail error: ${exception.message}');
      },
    );
  }

  /// 获取购物车数量（内部方法）
  Future<void> _getCartCount() async {
    await ShopDetailApi.getShopCartSum(
      onSuccess: (data) {
        _cartCount = data?.count ?? 0;
      },
      onError: (exception) {
        debugPrint('getCartCount error: ${exception.message}');
      },
    );
  }

  /// 获取评论列表
  Future<void> fetchCommentList(int id, {int page = 1}) async {
    _isLoadingComment = true;
    notifyListeners();

    await ShopDetailApi.getShopCommentList(
      id: id,
      page: page,
      onSuccess: (data) {
        _commentList = data;
        _isLoadingComment = false;
        notifyListeners();
      },
      onError: (exception) {
        _errorMessage = exception.message;
        _isLoadingComment = false;
        notifyListeners();
        debugPrint('fetchCommentList error: ${exception.message}');
      },
    );
  }

  /// 获取默认地址
  Future<void> fetchDefaultAddress() async {
    _isLoadingAddress = true;
    notifyListeners();

    await ShopDetailApi.getDefaultAddress(
      onSuccess: (data) {
        _defaultAddress = data;
        _isLoadingAddress = false;
        notifyListeners();
      },
      onError: (exception) {
        _isLoadingAddress = false;
        notifyListeners();
        debugPrint('fetchDefaultAddress error: ${exception.message}');
      },
    );
  }

  /// 获取推荐商品列表
  Future<void> fetchRecommendList({int page = 1}) async {
    _isLoadingRecommend = true;
    notifyListeners();

    await ShopDetailApi.getRecommendList(
      page: page,
      onSuccess: (data) {
        _recommendList = data;
        _isLoadingRecommend = false;
        notifyListeners();
      },
      onError: (exception) {
        _isLoadingRecommend = false;
        notifyListeners();
        debugPrint('fetchRecommendList error: ${exception.message}');
      },
    );
  }

  /// 添加购物车
  Future<bool> addToCart({
    required int cartNum,
    required String productId,
    String? productAttrUnique,
  }) async {
    final attrId = productAttrUnique ?? _selectedAttrId ?? '';

    bool success = false;
    await ShopDetailApi.addShopCart(
      cartNum: cartNum,
      productId: productId,
      productAttrUnique: attrId,
      onSuccess: (data) {
        if (data != null && data['cartId'] != null) {
          _cartId = data['cartId'].toString();
          _cartCount++;
          notifyListeners();
          success = true;
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
        debugPrint('addToCart error: ${exception.message}');
      },
    );

    return success;
  }

  /// 收藏商品
  Future<bool> collectShop(String id) async {
    bool success = false;
    await ShopDetailApi.collectShop(
      category: 'store',
      id: id,
      onSuccess: (data) {
        if (_shopDetail != null) {
          _shopDetail = ShopDetailEntity(
            productValueList: _shopDetail!.productValueList,
            userCollect: true,
            productAttr: _shopDetail!.productAttr,
            productInfo: _shopDetail!.productInfo,
          );
          notifyListeners();
          success = true;
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
        debugPrint('collectShop error: ${exception.message}');
      },
    );

    return success;
  }

  /// 取消收藏商品
  Future<bool> unCollectShop(String productId) async {
    bool success = false;
    await ShopDetailApi.unCollectShop(
      productId: productId,
      onSuccess: (data) {
        if (_shopDetail != null) {
          _shopDetail = ShopDetailEntity(
            productValueList: _shopDetail!.productValueList,
            userCollect: false,
            productAttr: _shopDetail!.productAttr,
            productInfo: _shopDetail!.productInfo,
          );
          notifyListeners();
          success = true;
        }
      },
      onError: (exception) {
        _errorMessage = exception.message;
        debugPrint('unCollectShop error: ${exception.message}');
      },
    );

    return success;
  }

  /// 更新选中的属性
  void updateSelectedAttr(String attrId, String? sku) {
    _selectedAttrId = attrId;
    _selectedSku = sku;
    notifyListeners();
  }

  /// 更新地址
  void updateAddress(AddressEntity? address) {
    _defaultAddress = address;
    notifyListeners();
  }

  /// 更新购物车数量
  void updateCartCount(int count) {
    _cartCount = count;
    notifyListeners();
  }

  @override
  void dispose() {
    // 清理资源，防止内存泄漏
    _shopDetail = null;
    _commentList = null;
    _defaultAddress = null;
    _recommendList = null;
    super.dispose();
  }
}
