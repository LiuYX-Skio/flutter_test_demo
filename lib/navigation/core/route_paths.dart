/// 路由路径常量类 - 提供类型安全的路由访问
class RoutePaths {
  const RoutePaths._();

  // ============ 基础路由 ============
  static const RoutePath home = RoutePath('home');
  static const RoutePath splash = RoutePath('splash');
  static const RoutePath welcome = RoutePath('welcome');

  // ============ 认证路由 ============
  static const AuthRoutes auth = AuthRoutes._();

  // ============ 用户路由 ============
  static const UserRoutes user = UserRoutes._();

  // ============ 商品路由 ============
  static const ProductRoutes product = ProductRoutes._();

  // ============ 其他路由 ============
  static const OtherRoutes other = OtherRoutes._();

  // ============ 便捷访问方法 ============

  /// 获取所有路由路径
  static List<RoutePath> get all => [
    home, splash, welcome,
    ...auth.all,
    ...user.all,
    ...product.all,
    ...other.all,
  ];

  /// 根据字符串路径查找路由对象
  static RoutePath? fromString(String path) {
    return all.firstWhere(
      (route) => route.path == path,
      orElse: () => throw ArgumentError('Unknown route path: $path'),
    );
  }
}

/// 路由路径基类
class RoutePath {
  const RoutePath(this.path);

  final String path;

  @override
  String toString() => path;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutePath && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

/// 认证相关路由
class AuthRoutes {
  const AuthRoutes._();

  final RoutePath login = const RoutePath('login');
  final RoutePath register = const RoutePath('auth/register');
  final RoutePath forgotPassword = const RoutePath('auth/forgot_password');
  final RoutePath verifyCode = const RoutePath('auth/verify_code');

  List<RoutePath> get all => [login, register, forgotPassword, verifyCode];
}

/// 用户相关路由
class UserRoutes {
  const UserRoutes._();

  final RoutePath profile = const RoutePath('user/profile');
  final RoutePath settings = const RoutePath('user/settings');
  final RoutePath editProfile = const RoutePath('user/edit_profile');
  final RoutePath changePassword = const RoutePath('user/change_password');
  final RoutePath avatarCrop = const RoutePath('user/avatar_crop');
  final RoutePath addressList = const RoutePath('user/address_list');
  final RoutePath addAddress = const RoutePath('user/add_address');
  final RoutePath accountSafe = const RoutePath('user/account_safe');
  final RoutePath accountSafeDetail = const RoutePath('user/account_safe_detail');
  final RoutePath wallet = const RoutePath('user/wallet');
  final RoutePath withdraw = const RoutePath('user/withdraw');
  final RoutePath withdrawRecord = const RoutePath('user/withdraw_record');
  final RoutePath charge = const RoutePath('user/charge');

  List<RoutePath> get all => [
    profile, settings, editProfile, changePassword, avatarCrop,
    addressList, addAddress, accountSafe, accountSafeDetail, wallet, withdraw,
    withdrawRecord, charge,
  ];
}

/// 商品相关路由
class ProductRoutes {
  const ProductRoutes._();

  final RoutePath list = const RoutePath('product/list');
  final RoutePath detail = const RoutePath('product/detail');
  final RoutePath sort = const RoutePath('product/sort');
  final RoutePath search = const RoutePath('product/search');
  final RoutePath commentList = const RoutePath('product/comment_list');
  final RoutePath bigPhoto = const RoutePath('product/big_photo');
  final RoutePath category = const RoutePath('product/category');
  final RoutePath cart = const RoutePath('product/cart');
  final RoutePath checkout = const RoutePath('product/checkout');
  final RoutePath orderConfirm = const RoutePath('product/order_confirm');

  List<RoutePath> get all => [
    list, detail, sort, search, commentList, bigPhoto, category, cart, checkout, orderConfirm
  ];
}

/// 其他功能路由
class OtherRoutes {
  const OtherRoutes._();

  final RoutePath notificationList = const RoutePath('notification/list');
  final RoutePath notificationDetail = const RoutePath('notification/detail');
  final RoutePath feedback = const RoutePath('feedback');
  final RoutePath about = const RoutePath('about');
  final RoutePath webview = const RoutePath('webview');
  final RoutePath share = const RoutePath('share');
  final RoutePath imagePreview = const RoutePath('image_preview');
  final RoutePath loading = const RoutePath('loading');
  final RoutePath confirm = const RoutePath('confirm');
  final RoutePath error = const RoutePath('error');

  // 月付相关路由
  final RoutePath supplementMessage = const RoutePath('home/supplement_message');
  final RoutePath authMessage = const RoutePath('home/auth_message');
  final RoutePath applyQuota = const RoutePath('home/apply_quota');
  final RoutePath monthBill = const RoutePath('mine/month_bill');
  final RoutePath limitMoney = const RoutePath('mine/limit_money');
  final RoutePath recallMoney = const RoutePath('mine/recall_money');
  final RoutePath examineIng = const RoutePath('mine/examine_ing');
  final RoutePath examineFail = const RoutePath('mine/examine_fail');
  final RoutePath newMonthPay = const RoutePath('mine/new_month_pay');
  final RoutePath backUpMoney = const RoutePath('mine/back_up_money');
  final RoutePath backUpSuccess = const RoutePath('mine/back_up_success');
  final RoutePath goldRecycle = const RoutePath('mine/gold_recycle');
  final RoutePath phoneRecycleMsg = const RoutePath('mine/phone_recycle_msg');
  final RoutePath recycleOrderList = const RoutePath('order/recycle_list');
  final RoutePath phoneRecycleOrder = const RoutePath('order/phone_recycle');
  final RoutePath shopCanRecycleList = const RoutePath('order/shop_can_recycle_list');
  final RoutePath shopRecycleDetail = const RoutePath('order/shop_recycle_detail');
  final RoutePath goldRecycleOrder = const RoutePath('order/gold_recycle_order');
  final RoutePath orderList = const RoutePath('order/list');
  final RoutePath orderDetail = const RoutePath('order/detail');
  final RoutePath orderPaySuccess = const RoutePath('order/pay_success');
  final RoutePath shopPay = const RoutePath('pay/shop_pay');
  final RoutePath orderComment = const RoutePath('order/comment');
  final RoutePath configOrder = const RoutePath('order/config');
  final RoutePath chatService = const RoutePath('chat/service');

  List<RoutePath> get all => [
    notificationList, notificationDetail, feedback, about,
    webview, share, imagePreview, loading, confirm, error,
    supplementMessage, authMessage, applyQuota, monthBill, limitMoney,
    recallMoney, examineIng, examineFail, newMonthPay, backUpMoney,
    backUpSuccess,
    goldRecycle, phoneRecycleMsg, recycleOrderList, phoneRecycleOrder,
    shopCanRecycleList, shopRecycleDetail, goldRecycleOrder,
    orderList, orderDetail, orderPaySuccess, shopPay, orderComment, configOrder,
    chatService,
  ];
}
