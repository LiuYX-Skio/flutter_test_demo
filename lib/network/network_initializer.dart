import 'package:flutter_test_demo/app/pages/login/models/login_models.dart';

import '../app/models/splash_models.dart' as splash;
import '../app/pages/home/models/home_models.dart';
import '../app/pages/home/models/product_models.dart';
import '../app/pages/home/models/auth_models.dart';
import '../app/pages/home/models/user_models.dart';
import '../app/pages/mine/models/mine_models.dart';
import '../app/pages/mine/models/address_models.dart';
import '../app/pages/mine/models/address_tree_models.dart';
import '../app/pages/home/models/address_models.dart';
import '../app/pages/order/models/order_models.dart';
import '../app/pages/pay/models/pay_models.dart';
import '../app/pages/shop/models/shop_detail_models.dart';
import '../app/pages/shop/models/shop_models.dart';
import 'json_converter_registry.dart';

/// 网络框架初始化器
/// 负责注册所有实体类的 JSON 转换器
class NetworkInitializer {
  static void init() {
    final registry = JsonConverterRegistry();

    // 注册启动页相关实体
    registry.register<splash.AppUpdateEntity>(
      (json) => splash.AppUpdateEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<splash.UserCreditEntity>(
      (json) => splash.UserCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<splash.IpAddressEntity>(
      (json) => splash.IpAddressEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<BannerEntity>(
      (json) => BannerEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<MenuCategoryEntity>(
      (json) => MenuCategoryEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ExplosiveMoneyEntity>(
      (json) => ExplosiveMoneyEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册商品相关实体
    registry.register<ProductEntity>(
      (json) => ProductEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册分页数据包装器
    registry.register<ShopOutEntity>(
      (json) => ShopOutEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册用户相关实体
    registry.register<UserInfoEntity>(
      (json) => UserInfoEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<UserCreditEntity>(
      (json) => UserCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<MyCreditEntity>(
      (json) => MyCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<MonthPayEntity>(
      (json) => MonthPayEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册月付相关实体
    registry.register<MineCreditEntity>(
      (json) => MineCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<UserMonthPayEntity>(
      (json) => UserMonthPayEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<UploadEntity>(
      (json) => UploadEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<UploadIdCardEntity>(
      (json) => UploadIdCardEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<WithDrawUserInfo>(
      (json) => WithDrawUserInfo.fromJson(json as Map<String, dynamic>),
    );

    registry.register<WithDrawRecordShell>(
      (json) => WithDrawRecordShell.fromJson(json as Map<String, dynamic>),
    );

    registry.register<WithDrawRecord>(
      (json) => WithDrawRecord.fromJson(json as Map<String, dynamic>),
    );

    registry.register<UserAddressListEntity>(
      (json) => UserAddressListEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<UserAddressEntity>(
      (json) => UserAddressEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<AddressProvince>(
      (json) => AddressProvince.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<AddressProvince>(
      (json) => AddressProvince.fromJson(json as Map<String, dynamic>),
    );

    // 注册地址实体
    registry.register<AddressEntity>(
      (json) => AddressEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册订单相关实体
    registry.register<OrderOutEntity>(
      (json) => OrderOutEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<OrderDetailEntity>(
      (json) => OrderDetailEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ConfigOrderOutEntity>(
      (json) => ConfigOrderOutEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ConfigOrderPriceEntity>(
      (json) => ConfigOrderPriceEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<OrderNoResultEntity>(
      (json) => OrderNoResultEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<GoldOutEntity>(
      (json) => GoldOutEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<RecycleShopOutEntity>(
      (json) => RecycleShopOutEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<RecycleShopEntity>(
      (json) => RecycleShopEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<GoldRecycleEntity>(
      (json) => GoldRecycleEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<PhoneRecycleEntity>(
      (json) => PhoneRecycleEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册商品详情相关实体
    registry.register<ShopDetailEntity>(
      (json) => ShopDetailEntity.fromJson(json as Map<String, dynamic>),
    );

    // 登录
    registry.register<UserInfo>(
      (json) => UserInfo.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopInfoEntity>(
      (json) => ShopInfoEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ProduceValueEntity>(
      (json) => ProduceValueEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopAttrEntity>(
      (json) => ShopAttrEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopAttrListEntity>(
      (json) => ShopAttrListEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopCommentEntity>(
      (json) => ShopCommentEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopCommentDetailEntity>(
      (json) => ShopCommentDetailEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopCommentOutEntity>(
      (json) => ShopCommentOutEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<ShopCarSumEntity>(
      (json) => ShopCarSumEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<MenuEntity>(
      (json) => MenuEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopSortEntity>(
      (json) => ShopSortEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopSortShopEntity>(
      (json) => ShopSortShopEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopCarEntity>(
      (json) => ShopCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopOutCarEntity>(
      (json) => ShopOutCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopAddCarEntity>(
      (json) => ShopAddCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<ShopPayEntity>(
      (json) => ShopPayEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<MonthPayRecallEntity>(
      (json) => MonthPayRecallEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.register<WxPayEntity>(
      (json) => WxPayEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册基本类型（String 类型特殊处理）
    registry.register<String>((json) => json as String);

    // 注册启动页相关实体的 List 转换器
    registry.registerListItem<splash.AppUpdateEntity>(
      (json) => splash.AppUpdateEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<splash.UserCreditEntity>(
      (json) => splash.UserCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<splash.IpAddressEntity>(
      (json) => splash.IpAddressEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册首页相关实体
    registry.register<HomeTitleDataEntity>(
      (json) {
        return HomeTitleDataEntity.fromJson(json);
      },
    );

    registry.registerListItem<BannerEntity>(
      (json) => BannerEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MenuCategoryEntity>(
      (json) => MenuCategoryEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ExplosiveMoneyEntity>(
      (json) => ExplosiveMoneyEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册商品相关实体的 List 转换器
    registry.registerListItem<ProductEntity>(
      (json) => ProductEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册用户相关实体的 List 转换器
    registry.registerListItem<UserInfoEntity>(
      (json) => UserInfoEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MyCreditEntity>(
      (json) => MyCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MonthPayEntity>(
      (json) => MonthPayEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MineCreditEntity>(
      (json) => MineCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<UserMonthPayEntity>(
      (json) => UserMonthPayEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<UploadIdCardEntity>(
      (json) => UploadIdCardEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MonthPayListEntity>(
      (json) => MonthPayListEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<WithDrawRecord>(
      (json) => WithDrawRecord.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<UserAddressEntity>(
      (json) => UserAddressEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册地址实体的 List 转换器
    registry.registerListItem<AddressEntity>(
      (json) => AddressEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopInfoEntity>(
      (json) => ShopInfoEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ProduceValueEntity>(
      (json) => ProduceValueEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopAttrEntity>(
      (json) => ShopAttrEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopAttrListEntity>(
      (json) => ShopAttrListEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopCommentEntity>(
      (json) => ShopCommentEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopCommentDetailEntity>(
      (json) => ShopCommentDetailEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopCommentOutEntity>(
      (json) => ShopCommentOutEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<ShopCarSumEntity>(
      (json) => ShopCarSumEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MenuEntity>(
      (json) => MenuEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopSortEntity>(
      (json) => ShopSortEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopSortShopEntity>(
      (json) => ShopSortShopEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopCarEntity>(
      (json) => ShopCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopOutCarEntity>(
      (json) => ShopOutCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopAddCarEntity>(
      (json) => ShopAddCarEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ShopPayEntity>(
      (json) => ShopPayEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<MonthPayRecallEntity>(
      (json) => MonthPayRecallEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<WxPayEntity>(
      (json) => WxPayEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册订单相关 List 转换器
    registry.registerListItem<OrderListEntity>(
      (json) => OrderListEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<OrderInfoListEntity>(
      (json) => OrderInfoListEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<CartInfoEntity>(
      (json) => CartInfoEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<ConfigOrderInfoEntity>(
      (json) => ConfigOrderInfoEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<GoldEntity>(
      (json) => GoldEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<RecycleShopEntity>(
      (json) => RecycleShopEntity.fromJson(json as Map<String, dynamic>),
    );
    registry.registerListItem<LogisticsEntity>(
      (json) => LogisticsEntity.fromJson(json as Map<String, dynamic>),
    );
  }
}
