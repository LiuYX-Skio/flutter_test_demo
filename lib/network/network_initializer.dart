import '../app/models/splash_models.dart' as splash;
import '../app/pages/home/models/home_models.dart';
import '../app/pages/home/models/product_models.dart';
import '../app/pages/home/models/user_models.dart';
import '../app/pages/home/models/address_models.dart';
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

    // 注册首页相关实体
    registry.register<HomeTitleDataEntity>(
      (json) => HomeTitleDataEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<BannerEntity>(
      (json) => BannerEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.register<MenuCategoryEntity>(
      (json) => MenuCategoryEntity.fromJson(json as Map<String, dynamic>),
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

    registry.register<MyCreditEntity>(
      (json) => MyCreditEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册地址实体
    registry.register<AddressEntity>(
      (json) => AddressEntity.fromJson(json as Map<String, dynamic>),
    );

    // 注册基本类型（String 类型特殊处理）
    registry.register<String>((json) => json as String);

    // ========== 注册 List 元素转换器 ==========
    // 用于处理 List<Entity> 类型的响应数据

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

    // 注册首页相关实体的 List 转换器
    registry.registerListItem<HomeTitleDataEntity>(
      (json) => HomeTitleDataEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<BannerEntity>(
      (json) => BannerEntity.fromJson(json as Map<String, dynamic>),
    );

    registry.registerListItem<MenuCategoryEntity>(
      (json) => MenuCategoryEntity.fromJson(json as Map<String, dynamic>),
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

    // 注册地址实体的 List 转换器
    registry.registerListItem<AddressEntity>(
      (json) => AddressEntity.fromJson(json as Map<String, dynamic>),
    );
  }
}
