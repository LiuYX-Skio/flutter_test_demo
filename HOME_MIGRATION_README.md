# MainActivity迁移到Flutter - 使用说明

## 项目概述

已成功将Android原生项目中的MainActivity及其4个tab fragments完全迁移到Flutter。

## 文件结构

```
lib/app/pages/home/
├── main_page.dart                    # 主页面（底部导航+PageView）
├── home_providers.dart               # Provider配置
├── models/                           # 数据模型（8个文件）
│   ├── home_models.dart
│   ├── product_models.dart
│   ├── user_models.dart
│   └── address_models.dart
├── viewmodels/                       # 状态管理（5个文件）
│   ├── main_viewmodel.dart
│   ├── home_viewmodel.dart
│   ├── sort_viewmodel.dart
│   ├── apply_quota_viewmodel.dart
│   └── mine_viewmodel.dart
├── views/                            # Tab视图（4个文件）
│   ├── home_tab_view.dart
│   ├── sort_tab_view.dart
│   ├── apply_quota_tab_view.dart
│   └── mine_tab_view.dart
├── widgets/                          # UI组件（11个文件）
│   ├── common/                       # 通用组件
│   ├── home/                         # 首页组件
│   ├── sort/                         # 排行榜组件
│   └── mine/                         # 我的页面组件
└── api/                              # API服务（3个文件）
    ├── home_api.dart
    ├── user_api.dart
    └── product_api.dart
```

## 使用方法

### 1. 在现有项目中使用

在你的主入口文件中添加：

```dart
import 'package:flutter_test_demo/app/pages/home/home_providers.dart';

// 在MaterialApp中使用
home: const HomeProviders(),
```

### 2. 独立测试

运行测试文件：

```bash
flutter run -t lib/main_home_test.dart
```

### 3. 配置API地址

在初始化时配置你的API基础URL：

```dart
HttpClient.instance.init(
  HttpConfig(
    baseUrl: 'https://your-api-base-url.com',
    connectTimeout: 30000,
    receiveTimeout: 30000,
    sendTimeout: 30000,
    enableLog: true,
  ),
);
```

## 功能特性

### 已实现功能

✅ 底部导航栏（4个Tab）
✅ 首页Tab（轮播图、菜单网格、商品列表）
✅ 排行榜Tab（排行榜列表）
✅ 月付申请Tab（额度信息、申请状态）
✅ 我的Tab（用户信息、功能入口、推荐商品）
✅ 下拉刷新和上拉加载更多
✅ 状态管理（Provider + ChangeNotifier）
✅ 网络请求（基于现有的HttpClient）
✅ 屏幕适配（flutter_screenutil）
✅ 图片缓存（cached_network_image）

### 核心技术栈

- **状态管理**: Provider + ChangeNotifier
- **网络请求**: Dio + 现有的HttpClient框架
- **路由管理**: Flutter Boost
- **屏幕适配**: flutter_screenutil
- **下拉刷新**: pull_to_refresh
- **轮播图**: carousel_slider
- **图片缓存**: cached_network_image

## API接口说明

### 首页相关

- `GET /api/app/index/data` - 获取首页数据
- `GET /api/app/index/premiumList` - 获取推荐商品列表
- `GET /api/app/index/ranking` - 获取排行榜列表

### 用户相关

- `GET /api/app/user/user` - 获取用户信息
- `GET /api/app/address/default` - 获取默认地址
- `GET /api/app/user-credit/user-credit` - 获取用户信用详情
- `GET /api/app/user-credit/my-credit` - 获取我的额度

### 商品相关

- `GET /api/app/product/hot` - 获取热门商品

## 注意事项

1. **API地址配置**: 需要在初始化时配置正确的API基础URL
2. **认证Token**: 如果需要认证，请配置AuthInterceptor
3. **错误处理**: 所有API调用都已包含try-catch错误处理
4. **性能优化**: 使用了AutomaticKeepAliveClientMixin保持Tab状态
5. **屏幕适配**: 所有尺寸都使用了flutter_screenutil（.w、.h、.sp、.r）

## 下一步工作

- [ ] 配置实际的API地址
- [ ] 添加认证Token处理
- [ ] 完善错误提示UI
- [ ] 添加骨架屏加载效果
- [ ] 性能测试和优化
- [ ] 集成到Flutter Boost路由系统
