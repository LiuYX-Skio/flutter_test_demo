import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_test_demo/app/pages/shop/shop_detail_page.dart';
import 'package:flutter_test_demo/app/pages/shop/views/shop_big_photo_page.dart';
import 'package:flutter_test_demo/app/pages/shop/views/shop_car_page.dart';
import 'package:flutter_test_demo/app/pages/shop/views/shop_comment_list_page.dart';
import 'package:flutter_test_demo/app/pages/shop/views/shop_search_page.dart';
import 'package:flutter_test_demo/app/pages/shop/views/shop_sort_page.dart';
import 'package:flutter_test_demo/app/pages/shop/viewmodels/shop_car_viewmodel.dart';
import 'package:flutter_test_demo/app/pages/shop/viewmodels/shop_comment_viewmodel.dart';
import 'package:flutter_test_demo/app/pages/shop/viewmodels/shop_search_viewmodel.dart';
import 'package:flutter_test_demo/app/pages/shop/viewmodels/shop_sort_viewmodel.dart';
import 'package:flutter_test_demo/app/pages/splash/splash_page.dart';
import 'route_definition.dart';
import 'route_paths.dart';
import '../config/route_config.dart';
import '../../app/pages/home/home_providers.dart';
import '../../app/pages/home/views/apply_quota_tab_view.dart';
import '../../app/pages/home/viewmodels/apply_quota_viewmodel.dart';
import '../../app/pages/home/views/auth_message_page.dart';
import '../../app/pages/home/views/supplement_message_page.dart';
import '../../app/pages/login/login_providers.dart';
import '../../app/pages/webview/webview_page.dart';
import '../../app/pages/mine/views/mine_bill_page.dart';
import '../../app/pages/mine/views/limit_money_page.dart';
import '../../app/pages/mine/views/recall_money_page.dart';
import '../../app/pages/mine/views/examine_ing_page.dart';
import '../../app/pages/mine/views/examine_fail_page.dart';
import '../../app/pages/mine/viewmodels/month_pay_viewmodel.dart';
import '../../app/pages/mine/views/system_setting_page.dart';
import '../../app/pages/mine/views/account_safe_page.dart';
import '../../app/pages/mine/views/account_safe_detail_page.dart';
import '../../app/pages/mine/views/person_user_info_page.dart';
import '../../app/pages/mine/views/mine_wallet_page.dart';
import '../../app/pages/mine/views/with_draw_page.dart';
import '../../app/pages/mine/views/with_draw_record_page.dart';
import '../../app/pages/mine/views/about_mine_page.dart';
import '../../app/pages/mine/views/mine_charge_page.dart';
import '../../app/pages/mine/views/back_up_money_page.dart';
import '../../app/pages/mine/views/back_up_success_page.dart';
import '../../app/pages/mine/views/phone_recycle_msg_page.dart';
import '../../app/pages/mine/viewmodels/wallet_viewmodel.dart';
import '../../app/pages/mine/views/address_list_page.dart';
import '../../app/pages/mine/viewmodels/address_viewmodel.dart';
import '../../app/pages/mine/views/add_address_page.dart';
import '../../app/pages/order/views/order_list_page.dart';
import '../../app/pages/order/views/order_detail_page.dart';
import '../../app/pages/order/views/pay_success_page.dart';
import '../../app/pages/order/views/order_comment_page.dart';
import '../../app/pages/order/views/config_order_page.dart';
import '../../app/pages/order/views/shop_recycle_page.dart';
import '../../app/pages/order/views/phone_recycle_order_page.dart';
import '../../app/pages/order/views/shop_recycle_list_page.dart';
import '../../app/pages/order/views/shop_can_recycle_list_page.dart';
import '../../app/pages/order/views/shop_recycle_detail_page.dart';
import '../../app/pages/order/views/gold_recycle_order_page.dart';
import '../../app/pages/order/viewmodels/order_detail_viewmodel.dart';
import '../../app/pages/order/viewmodels/config_order_viewmodel.dart';
import '../../app/pages/order/models/order_models.dart';
import '../../app/pages/pay/views/new_month_pay_page.dart';
import '../../app/pages/pay/views/shop_pay_page.dart';
import '../../app/pages/chat/views/chat_service_page.dart';
import '../../app/pages/chat/viewmodels/chat_viewmodel.dart';
import 'package:provider/provider.dart';

/// 路由注册器 - 统一管理所有路由注册
class RouteRegistry {
  static final RouteRegistry _instance = RouteRegistry._internal();

  factory RouteRegistry() => _instance;

  RouteRegistry._internal();

  /// 初始化所有路由
  void initialize() {
    // 注册基础路由
    _registerBaseRoutes();

    // 注册功能模块路由
    _registerAuthRoutes();
    _registerUserRoutes();
    _registerProductRoutes();
    _registerOtherRoutes();

    // 注册全局中间件
    _registerGlobalMiddlewares();
  }

  /// 获取 Flutter Boost 路由工厂
  Map<String, FlutterBoostRouteFactory> getBoostRouteFactory() {
    final routes = <String, FlutterBoostRouteFactory>{};

    for (final routeEntry in RouteConfig().allRoutes.entries) {
      final route = routeEntry.value;
      routes[route.name] = _createBoostRouteFactory(route);
    }

    return routes;
  }

  /// 注册基础路由
  void _registerBaseRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.home.path: RouteDefinition(
        name: RoutePaths.home.path,
        builder: (context) => const HomeProviders(),
      ),
      RoutePaths.splash.path: RouteDefinition(
        name: RoutePaths.splash.path,
        builder: (context) => const SplashPage(),
      ),
      RoutePaths.welcome.path: RouteDefinition(
        name: RoutePaths.welcome.path,
        builder: (context) => const _PlaceholderPage(title: '欢迎页'),
      ),
    });
  }

  /// 注册认证相关路由
  void _registerAuthRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.auth.login.path: RouteDefinition(
        name: RoutePaths.auth.login.path,
        builder: (context) => const LoginProviders(),
      ),
      RoutePaths.auth.register.path: RouteDefinition(
        name: RoutePaths.auth.register.path,
        builder: (context) => const _PlaceholderPage(title: '注册'),
      ),
      RoutePaths.auth.forgotPassword.path: RouteDefinition(
        name: RoutePaths.auth.forgotPassword.path,
        builder: (context) => const _PlaceholderPage(title: '忘记密码'),
      ),
      RoutePaths.auth.verifyCode.path: RouteDefinition.dialog(
        name: RoutePaths.auth.verifyCode.path,
        builder: (context) => const _PlaceholderPage(title: '验证码'),
        opaque: false,
      ),
    });
  }

  /// 注册用户相关路由
  void _registerUserRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.user.profile.path: RouteDefinition(
        name: RoutePaths.user.profile.path,
        builder: (context) => const PersonUserInfoPage(),
        withContainer: true,
      ),
      RoutePaths.user.settings.path: RouteDefinition(
        name: RoutePaths.user.settings.path,
        builder: (context) => const SystemSettingPage(),
      ),
      RoutePaths.user.editProfile.path: RouteDefinition(
        name: RoutePaths.user.editProfile.path,
        builder: (context) => const _PlaceholderPage(title: '编辑资料'),
      ),
      RoutePaths.user.changePassword.path: RouteDefinition(
        name: RoutePaths.user.changePassword.path,
        builder: (context) => const _PlaceholderPage(title: '修改密码'),
      ),
      RoutePaths.user.avatarCrop.path: RouteDefinition.dialog(
        name: RoutePaths.user.avatarCrop.path,
        builder: (context) => const _PlaceholderPage(title: '裁剪头像'),
        opaque: false,
      ),
      RoutePaths.user.addressList.path: RouteDefinition(
        name: RoutePaths.user.addressList.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AddressViewModel(),
          child: const AddressListPage(),
        ),
      ),
      RoutePaths.user.addAddress.path: RouteDefinition(
        name: RoutePaths.user.addAddress.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final addressId = args?['addressId'] as String?;
          return ChangeNotifierProvider(
            create: (_) => AddressViewModel(),
            child: AddAddressPage(addressId: addressId),
          );
        },
      ),
      RoutePaths.user.accountSafe.path: RouteDefinition(
        name: RoutePaths.user.accountSafe.path,
        builder: (context) => const AccountSafePage(),
      ),
      RoutePaths.user.accountSafeDetail.path: RouteDefinition(
        name: RoutePaths.user.accountSafeDetail.path,
        builder: (context) => const AccountSafeDetailPage(),
      ),
      RoutePaths.user.wallet.path: RouteDefinition(
        name: RoutePaths.user.wallet.path,
        builder: (context) => const MineWalletPage(),
      ),
      RoutePaths.user.withdraw.path: RouteDefinition(
        name: RoutePaths.user.withdraw.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => WalletViewModel(),
          child: const WithDrawPage(),
        ),
      ),
      RoutePaths.user.withdrawRecord.path: RouteDefinition(
        name: RoutePaths.user.withdrawRecord.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => WalletViewModel(),
          child: const WithDrawRecordPage(),
        ),
      ),
      RoutePaths.user.charge.path: RouteDefinition(
        name: RoutePaths.user.charge.path,
        builder: (context) => const MineChargePage(),
      ),
    });
  }

  /// 注册商品相关路由
  void _registerProductRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.product.list.path: RouteDefinition(
        name: RoutePaths.product.list.path,
        builder: (context) => const _PlaceholderPage(title: '商品列表'),
      ),
      RoutePaths.product.detail.path: RouteDefinition(
        name: RoutePaths.product.detail.path,
        builder: (context) {
          // 从路由参数中获取商品ID
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final productId = args?['id'] as int? ?? 0;
          return ShopDetailPage(productId: productId);
        },
      ),
      RoutePaths.product.sort.path: RouteDefinition(
        name: RoutePaths.product.sort.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ChangeNotifierProvider(
            create: (_) => ShopSortViewModel(),
            child: ShopSortPage(sortId: args?['sortId'] as String?),
          );
        },
      ),
      RoutePaths.product.search.path: RouteDefinition(
        name: RoutePaths.product.search.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ShopSearchViewModel(),
          child: const ShopSearchPage(),
        ),
      ),
      RoutePaths.product.commentList.path: RouteDefinition(
        name: RoutePaths.product.commentList.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final id = args?['id'] as int? ?? 0;
          return ChangeNotifierProvider(
            create: (_) => ShopCommentViewModel(),
            child: ShopCommentListPage(productId: id),
          );
        },
      ),
      RoutePaths.product.bigPhoto.path: RouteDefinition(
        name: RoutePaths.product.bigPhoto.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ShopBigPhotoPage(photo: args?['photo'] as String?);
        },
        type: RouteType.transparentDialog,
        withContainer: false,
        opaque: false,
        barrierColor: null,
      ),
      RoutePaths.product.category.path: RouteDefinition(
        name: RoutePaths.product.category.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ChangeNotifierProvider(
            create: (_) => ShopSortViewModel(),
            child: ShopSortPage(sortId: args?['sortId'] as String?),
          );
        },
      ),
      RoutePaths.product.cart.path: RouteDefinition(
        name: RoutePaths.product.cart.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ShopCarViewModel(),
          child: const ShopCarPage(),
        ),
      ),
      RoutePaths.product.checkout.path: RouteDefinition(
        name: RoutePaths.product.checkout.path,
        builder: (context) => const _PlaceholderPage(title: '结算'),
      ),
      RoutePaths.product.orderConfirm.path: RouteDefinition.dialog(
        name: RoutePaths.product.orderConfirm.path,
        builder: (context) => const _PlaceholderPage(title: '订单确认'),
        opaque: false,
      ),
    });
  }

  /// 注册其他功能路由
  void _registerOtherRoutes() {
    RouteConfig().registerRoutes({
      RoutePaths.other.notificationList.path: RouteDefinition(
        name: RoutePaths.other.notificationList.path,
        builder: (context) => const _PlaceholderPage(title: '消息列表'),
      ),
      RoutePaths.other.notificationDetail.path: RouteDefinition(
        name: RoutePaths.other.notificationDetail.path,
        builder: (context) => const _PlaceholderPage(title: '消息详情'),
      ),
      RoutePaths.other.feedback.path: RouteDefinition(
        name: RoutePaths.other.feedback.path,
        builder: (context) => const _PlaceholderPage(title: '意见反馈'),
      ),
      RoutePaths.other.about.path: RouteDefinition(
        name: RoutePaths.other.about.path,
        builder: (context) => const AboutMinePage(),
      ),
      RoutePaths.other.webview.path: RouteDefinition(
        name: RoutePaths.other.webview.path,
        builder: (context) {
          // 从路由参数中获取URL和标题
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final url = args?['url'] as String? ?? '';
          final title = args?['title'] as String? ?? '网页视图';
          return WebViewPage(url: url, title: title);
        },
        withContainer: true,
      ),
      RoutePaths.other.share.path: RouteDefinition(
        name: RoutePaths.other.share.path,
        builder: (context) => const _PlaceholderPage(title: '分享'),
        type: RouteType.bottomSheet,
        withContainer: false,
        opaque: false,
      ),
      RoutePaths.other.imagePreview.path: RouteDefinition(
        name: RoutePaths.other.imagePreview.path,
        builder: (context) => const _PlaceholderPage(title: '图片预览'),
        type: RouteType.transparentDialog,
        withContainer: false,
        opaque: false,
        barrierColor: null,
      ),
      RoutePaths.other.loading.path: RouteDefinition(
        name: RoutePaths.other.loading.path,
        builder: (context) => const _PlaceholderPage(title: '加载中'),
        type: RouteType.transparentDialog,
        withContainer: false,
        opaque: false,
        barrierColor: null,
      ),
      RoutePaths.other.confirm.path: RouteDefinition.dialog(
        name: RoutePaths.other.confirm.path,
        builder: (context) => const _PlaceholderPage(title: '确认对话框'),
        opaque: false,
      ),
      RoutePaths.other.error.path: RouteDefinition.dialog(
        name: RoutePaths.other.error.path,
        builder: (context) => const _PlaceholderPage(title: '错误提示'),
        opaque: false,
      ),
      // 月付相关路由
      RoutePaths.other.supplementMessage.path: RouteDefinition(
        name: RoutePaths.other.supplementMessage.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return SupplementMessagePage(
            isNeedClose: args?['isNeedClose'] as bool? ?? false,
          );
        },
        withContainer: true,
      ),
      RoutePaths.other.authMessage.path: RouteDefinition(
        name: RoutePaths.other.authMessage.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return AuthMessagePage(
            hasApply: args?['hasApply'] as bool? ?? false,
            isNeedClose: args?['isNeedClose'] as bool? ?? false,
          );
        },
        withContainer: true,
      ),
      RoutePaths.other.applyQuota.path: RouteDefinition(
        name: RoutePaths.other.applyQuota.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ChangeNotifierProvider(
            create: (_) => ApplyQuotaViewModel(),
            child: ApplyQuotaTabView(
              showBackButton: args?['showBackButton'] as bool? ?? false,
            ),
          );
        },
      ),
      RoutePaths.other.monthBill.path: RouteDefinition(
        name: RoutePaths.other.monthBill.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => MonthPayViewModel(),
          child: const MineBillPage(),
        ),
      ),
      RoutePaths.other.limitMoney.path: RouteDefinition(
        name: RoutePaths.other.limitMoney.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => MonthPayViewModel(),
          child: const LimitMoneyPage(),
        ),
      ),
      RoutePaths.other.recallMoney.path: RouteDefinition(
        name: RoutePaths.other.recallMoney.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return RecallMoneyPage(args: args ?? {});
        },
      ),
      RoutePaths.other.examineIng.path: RouteDefinition(
        name: RoutePaths.other.examineIng.path,
        builder: (context) => const ExamineIngPage(),
      ),
      RoutePaths.other.examineFail.path: RouteDefinition(
        name: RoutePaths.other.examineFail.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final nextApplyTime = args?['nextApplyTime'] as String?;
          return ExamineFailPage(nextApplyTime: nextApplyTime);
        },
      ),
      RoutePaths.other.newMonthPay.path: RouteDefinition(
        name: RoutePaths.other.newMonthPay.path,
        builder: (context) => const NewMonthPayPage(),
      ),
      RoutePaths.other.backUpMoney.path: RouteDefinition(
        name: RoutePaths.other.backUpMoney.path,
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MonthPayViewModel()),
            ChangeNotifierProvider(create: (_) => WalletViewModel()),
          ],
          child: const BackUpMoneyPage(),
        ),
      ),
      RoutePaths.other.backUpSuccess.path: RouteDefinition(
        name: RoutePaths.other.backUpSuccess.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return BackUpSuccessPage(
            alipayCode: args?['alipayCode']?.toString(),
            money: args?['money']?.toString(),
            extractPrice: args?['extractPrice']?.toString(),
            handlingFee: args?['handlingFee']?.toString(),
            purpose: args?['purpose']?.toString(),
            name: args?['name']?.toString(),
          );
        },
      ),
      RoutePaths.other.goldRecycle.path: RouteDefinition(
        name: RoutePaths.other.goldRecycle.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ShopRecyclePage(
            id: args?['id'] as String?,
            recyclePrice: args?['recyclePrice'] as String?,
            expressNumber: args?['expressNumber'] as String?,
            orderInfoId: args?['orderInfoId'] as String?,
          );
        },
      ),
      RoutePaths.other.phoneRecycleMsg.path: RouteDefinition(
        name: RoutePaths.other.phoneRecycleMsg.path,
        builder: (context) => const PhoneRecycleMsgPage(),
      ),
      RoutePaths.other.recycleOrderList.path: RouteDefinition(
        name: RoutePaths.other.recycleOrderList.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final recycleType = args?['recycleType'] as String? ?? '1';
          final currentPage = args?['currentPage'] as int? ?? 0;
          return ShopRecycleListPage(
            recycleType: recycleType,
            currentPage: currentPage,
          );
        },
      ),
      RoutePaths.other.phoneRecycleOrder.path: RouteDefinition(
        name: RoutePaths.other.phoneRecycleOrder.path,
        builder: (context) => const PhoneRecycleOrderPage(),
      ),
      RoutePaths.other.shopCanRecycleList.path: RouteDefinition(
        name: RoutePaths.other.shopCanRecycleList.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final recycleType = args?['recycleType'] as String? ?? '1';
          return ShopCanRecycleListPage(recycleType: recycleType);
        },
      ),
      RoutePaths.other.shopRecycleDetail.path: RouteDefinition(
        name: RoutePaths.other.shopRecycleDetail.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ShopRecycleDetailPage(
            id: args?['id'] as String? ?? '',
            pageType: args?['pageType'] as int? ?? 1,
            pageSource: args?['pageSource'] as int? ?? 0,
            isCanCancelOrder: args?['isCanCancelOrder'] as bool? ?? true,
          );
        },
      ),
      RoutePaths.other.goldRecycleOrder.path: RouteDefinition(
        name: RoutePaths.other.goldRecycleOrder.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final currentPage = args?['currentPage'] as int? ?? 0;
          return GoldRecycleOrderPage(currentPage: currentPage);
        },
      ),
      RoutePaths.other.orderList.path: RouteDefinition(
        name: RoutePaths.other.orderList.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final currentPage = args?['currentPage'] as int? ?? 0;
          final isSelectDeliver = args?['isSelectDeliver'] as bool? ?? false;
          return OrderListPage(
            currentPage: currentPage,
            isSelectDeliver: isSelectDeliver,
          );
        },
      ),
      RoutePaths.other.orderDetail.path: RouteDefinition(
        name: RoutePaths.other.orderDetail.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final orderId = args?['orderId'] as String? ?? '';
          return ChangeNotifierProvider(
            create: (_) => OrderDetailViewModel(),
            child: OrderDetailPage(orderId: orderId),
          );
        },
      ),
      RoutePaths.other.orderPaySuccess.path: RouteDefinition(
        name: RoutePaths.other.orderPaySuccess.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final orderId = args?['orderId'] as String? ?? '';
          return ChangeNotifierProvider(
            create: (_) => OrderDetailViewModel(),
            child: PaySuccessPage(orderId: orderId),
          );
        },
      ),
      RoutePaths.other.shopPay.path: RouteDefinition(
        name: RoutePaths.other.shopPay.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ShopPayPage(
            orderNo: _asString(args?['orderNo']),
            orderId: _asString(args?['orderId']),
            payMoney: _asString(args?['payMoney']),
            hasMonthCredit: _asBool(args?['hasMonthCredit']) ?? true,
            viewType: _asInt(args?['viewType']) ?? 0,
          );
        },
      ),
      RoutePaths.other.orderComment.path: RouteDefinition(
        name: RoutePaths.other.orderComment.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          return ChangeNotifierProvider(
            create: (_) => OrderDetailViewModel(),
            child: OrderCommentPage(
              productId: args?['productId'] as String?,
              orderNo: args?['orderNo'] as String?,
              storeName: args?['storeName'] as String?,
              imageUrl: args?['image'] as String?,
            ),
          );
        },
      ),
      RoutePaths.other.configOrder.path: RouteDefinition(
        name: RoutePaths.other.configOrder.path,
        builder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final items = _parseConfigOrderItems(args);
          final addressId = _asString(args?['addressId']);
          final preOrderType =
              _asString(args?['preOrderType']) ??
              _asString((args?['preOrderData'] as Map?)?['preOrderType']);
          return ChangeNotifierProvider(
            create: (_) => ConfigOrderViewModel(),
            child: ConfigOrderPage(
              items: items,
              addressId: addressId,
              preOrderType: preOrderType,
            ),
          );
        },
      ),
      RoutePaths.other.chatService.path: RouteDefinition(
        name: RoutePaths.other.chatService.path,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ChatViewModel(),
          child: const ChatServicePage(),
        ),
      ),
    });
  }

  /// 注册全局中间件
  void _registerGlobalMiddlewares() {
    // 这里可以注册一些基础的全局中间件
    // RouteConfig().registerGlobalMiddleware(LoggingMiddleware());
    // RouteConfig().registerGlobalMiddleware(CrashReportingMiddleware());
  }

  List<ConfigOrderDeliveryEntity> _parseConfigOrderItems(
    Map<String, dynamic>? args,
  ) {
    if (args == null) return const <ConfigOrderDeliveryEntity>[];

    final dynamic rawItems = args['items'];
    final List<ConfigOrderDeliveryEntity> itemsFromItems =
        _parseConfigOrderItemsFromRaw(rawItems);
    if (itemsFromItems.isNotEmpty) return itemsFromItems;

    final dynamic preOrderData = args['preOrderData'];
    if (preOrderData is Map) {
      return _parseConfigOrderItemsFromRaw(preOrderData['data']);
    }
    return const <ConfigOrderDeliveryEntity>[];
  }

  List<ConfigOrderDeliveryEntity> _parseConfigOrderItemsFromRaw(dynamic raw) {
    if (raw is! List) return const <ConfigOrderDeliveryEntity>[];
    final List<ConfigOrderDeliveryEntity> result = <ConfigOrderDeliveryEntity>[];
    for (final dynamic element in raw) {
      if (element is ConfigOrderDeliveryEntity) {
        result.add(element);
        continue;
      }
      if (element is Map) {
        final entity = ConfigOrderDeliveryEntity(
          attrValueId: _asString(element['attrValueId']),
          orderNo: _asString(element['orderNo']),
          productId: _asString(element['productId']),
          productNum: _asInt(element['productNum']) ?? 1,
          sku: _asString(element['sku']),
          shoppingCartId: _asString(element['shoppingCartId']),
        );
        result.add(entity);
      }
    }
    return result;
  }

  String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  bool? _asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final raw = value.toString().toLowerCase();
    if (raw == '1' || raw == 'true') return true;
    if (raw == '0' || raw == 'false') return false;
    return null;
  }

  /// 创建 Flutter Boost 路由工厂
  FlutterBoostRouteFactory _createBoostRouteFactory(RouteDefinition route) {
    return (RouteSettings settings, bool isContainerPage, String? uniqueId) {
      switch (route.type) {
        case RouteType.page:
          return CupertinoPageRoute<dynamic>(
            settings: settings,
            builder: route.builder, // 直接透传builder
            maintainState: route.maintainState,
            fullscreenDialog: route.fullscreenDialog,
          );

        case RouteType.dialog:
          return CupertinoDialogRoute<dynamic>(
            settings: settings,
            context: settings.arguments as BuildContext,
            // 需透传context（关键）
            builder: (context) => route.builder(context),
            barrierColor: route.barrierColor ?? Colors.black54,
            barrierDismissible: true, // 点击遮罩关闭（可配置）
          );

        case RouteType.transparentDialog:
          return PageRouteBuilder<dynamic>(
            settings: settings,
            opaque: false,
            // 透明核心
            barrierColor: route.barrierColor ?? Colors.black12,
            maintainState: route.maintainState,
            // 模拟 Cupertino 动画
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: false,
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) =>
                route.builder(context),
          );

        case RouteType.bottomSheet:
          return CupertinoModalPopupRoute<dynamic>(
            settings: settings,
            builder: route.builder, // 底部弹窗内容
            barrierColor: route.barrierColor ?? Colors.black12,
            barrierDismissible: true, // 点击遮罩关闭
          );
      }
    };
  }

  /// 动态注册路由（运行时添加）
  void registerRoute(RouteDefinition route) {
    RouteConfig().registerRoute(route);
  }

  /// 批量注册路由（运行时添加）
  void registerRoutes(Map<String, RouteDefinition> routes) {
    RouteConfig().registerRoutes(routes);
  }

  /// 移除路由
  void unregisterRoute(String routeName) {
    RouteConfig().removeRoute(routeName);
  }

  /// 清空所有路由
  void clearRoutes() {
    RouteConfig().clearRoutes();
  }

  /// 获取所有已注册的路由
  Map<String, RouteDefinition> get allRoutes => RouteConfig().allRoutes;

  /// 检查路由是否存在
  bool hasRoute(String routeName) => RouteConfig().hasRoute(routeName);
}

/// 占位页面组件 - 用于开发阶段
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Text(
              '这是一个占位页面\n请替换为实际的页面组件',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
