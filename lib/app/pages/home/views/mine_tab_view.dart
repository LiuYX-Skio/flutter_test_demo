import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app/widgets/refresh_list_widget.dart';
import 'package:flutter_test_demo/navigation/core/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/mine_viewmodel.dart';
import '../widgets/mine/user_order_view.dart';
import '../widgets/mine/shop_recommend_view.dart';
import '../../mine/widgets/user_month_view.dart';
import '../../../../app/provider/user_provider.dart';

/// 我的Tab视图 - 完全按照Android MineFragment实现
class MineTabView extends StatefulWidget {
  const MineTabView({super.key});

  @override
  State<MineTabView> createState() => _MineTabViewState();
}

class _MineTabViewState extends State<MineTabView>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late MineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    // 延迟初始化 - 对应Android的initFragment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<MineViewModel>(context, listen: false);
      // 初始化商品列表 - 对应Android的recommendList(true)
      _viewModel.recommendList(true, 1, 20);
      _viewModel.fetchUserInfo();
      _viewModel.fetchUserCreditDetail();
      UserProvider.updateUserInfo().then((_) {
        _viewModel.updateUserState();
      });
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<MineViewModel>(
      builder: (context, viewModel, child) {
        return RefreshListWidget(
          controller: _refreshController,
          enablePullDown: false, // Android中srlEnableRefresh="false"
          enablePullUp: true,
          onLoading: _onLoading,
          child: Container(
            color: const Color(0xFFF7F9FC), // color_F7F9FC
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 顶部用户信息区域
                  _buildTopUserInfo(viewModel),

                  // 月付视图
                  if (viewModel.isMonthPayOpen) _buildMonthPayView(viewModel),

                  // 回收模块
                  if (_shouldShowRecycleModule(viewModel)) _buildRecycleModule(),

                  // 商品推荐列表
                  _buildProductRecommendList(viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 顶部用户信息区域 (RelativeLayout, 高度280dp)
  Widget _buildTopUserInfo(MineViewModel viewModel) {
    return Container(
      height: 280.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mine_top.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(
        left: 12.w,
        top: 58.h,
      ),
      child: Column(
        children: [
          // 用户头像和信息行
          Row(
            children: [
              // 头像
              GestureDetector(
                onTap: () => _onAvatarTap(viewModel),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.w),
                    image: DecorationImage(
                      image: viewModel.userAvatar != null
                          ? NetworkImage(viewModel.userAvatar!)
                          : const AssetImage('assets/images/icon_default.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // 用户信息
              Expanded(
                child: GestureDetector(
                  onTap: () => _onUserInfoTap(viewModel),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.userName,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A), // color_1A1A1A
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        viewModel.userPhone,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF333333), // color_333333
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 右侧功能按钮
              Row(
                children: [
                  // 购物车
                  _buildTopIconButton(
                    'assets/images/icon_gwc.png',
                    '购物车',
                    () => _onShopCarTap(viewModel),
                    marginEnd: 15.w,
                  ),

                  // 设置
                  _buildTopIconButton(
                    'assets/images/icon_sz.png',
                    '设置',
                    () => _onSettingTap(),
                    marginEnd: 15.w,
                  ),

                  // 客服
                  _buildTopIconButton(
                    'assets/images/icon_kf.png',
                    '客服',
                    () => _onServiceTap(viewModel),
                    marginEnd: 18.w,
                  ),

                  // 钱包 (根据条件显示)
                  if (_shouldShowWallet()) _buildTopIconButton(
                    'assets/images/mine_wallet.webp',
                    '钱包',
                    () => _onWalletTap(viewModel),
                    marginEnd: 18.w,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // 订单视图 (UserOrderView)
          _buildUserOrderView(),
        ],
      ),
    );
  }

  /// 顶部图标按钮
  Widget _buildTopIconButton(String iconPath, String title, VoidCallback onTap, {required double marginEnd}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: marginEnd.w),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 22.w,
              height: 22.w,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xFF333333), // color_333333
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 用户订单视图 (UserOrderView)
  Widget _buildUserOrderView() {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: const UserOrderView(),
    );
  }

  /// 月付视图 (UserMonthView)
  Widget _buildMonthPayView(MineViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 10.h,
      ),
      child: UserMonthView(
        monthPayInfo: viewModel.userInfo?.creditAppUser,
        onMonthApply: () => _onMonthApply(viewModel),
        onMonthBill: _onMonthBill,
      ),
    );
  }

  /// 回收模块
  Widget _buildRecycleModule() {
    return Container(
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 10.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: GestureDetector(
        onTap: _onRecycleTap,
        child: Image.asset(
          'assets/images/sphss.png',
          height: 60.h,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  /// 商品推荐列表 (ShopRecommendView)
  Widget _buildProductRecommendList(MineViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: ShopRecommendView(products: viewModel.productList),
    );
  }

  /// 判断是否显示回收模块
  bool _shouldShowRecycleModule(MineViewModel viewModel) {
    // 根据Android逻辑：测试账号不显示，有月付开通时显示
    return !viewModel.isTestAccount && viewModel.isMonthPayOpen;
  }

  /// 判断是否显示钱包按钮
  bool _shouldShowWallet() {
    // Android中钱包默认gone，需要根据条件控制
    return false; // 暂时隐藏，待业务逻辑完善
  }

  /// 事件处理方法
  void _onAvatarTap(MineViewModel viewModel) {
    if (!viewModel.isLogin) {
      context.nav.push(RoutePaths.auth.login);
    } else {
      context.nav.push(RoutePaths.user.profile);
    }
  }

  void _onUserInfoTap(MineViewModel viewModel) {
    if (!viewModel.isLogin) {
      context.nav.push(RoutePaths.auth.login);
    } else {
      context.nav.push(RoutePaths.user.profile);
    }
  }

  void _onShopCarTap(MineViewModel viewModel) {
    if (viewModel.isLogin) {
      context.nav.push(RoutePaths.product.cart);
    } else {
      context.nav.push(RoutePaths.auth.login);
    }
  }

  void _onSettingTap() {
    context.nav.push(RoutePaths.user.settings);
  }

  void _onServiceTap(MineViewModel viewModel) {
    if (viewModel.isLogin) {
      context.nav.push(RoutePaths.other.chatService);
    } else {
      context.nav.push(RoutePaths.auth.login);
    }
  }

  void _onWalletTap(MineViewModel viewModel) {
    if (viewModel.isLogin) {
      context.nav.push(RoutePaths.user.wallet);
    } else {
      context.nav.push(RoutePaths.auth.login);
    }
  }

  void _onRecycleTap() {
    context.nav.push(RoutePaths.other.phoneRecycleMsg);
  }

  Future<void> _onMonthApply(MineViewModel viewModel) async {
    if (!viewModel.isLogin) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }

    await viewModel.fetchUserCreditDetail();
    final creditDetail = viewModel.userCreditDetail;
    final hasApply = creditDetail?.hasApply == true;
    final status = creditDetail?.status ?? 0;

    if (hasApply) {
      if (status == 2) {
        if (viewModel.isTestAccount) {
          context.nav.push(RoutePaths.other.newMonthPay);
        } else {
          context.nav.push(RoutePaths.other.limitMoney);
        }
      } else if (status == 1) {
        context.nav.push(RoutePaths.other.examineIng);
      } else if (status == 3) {
        context.nav.push(
          RoutePaths.other.examineFail,
          arguments: {'nextApplyTime': creditDetail?.nextApplyTime},
        );
      } else {
        if (viewModel.userInfo?.hasAuthentication == true) {
          context.nav.push(RoutePaths.other.supplementMessage);
        } else {
          context.nav.push(
            RoutePaths.other.applyQuota,
            arguments: {'hasApply': true},
          );
        }
      }
    } else {
      context.nav.push(
        RoutePaths.other.applyQuota,
        arguments: {'hasApply': false},
      );
    }
  }

  void _onMonthBill() {
    context.nav.push(RoutePaths.other.monthBill);
  }

  void _onLoading() async {
    // 对应Android的recommendList() - 加载更多
    final nextPage = _viewModel.currentPage + 1;
    await _viewModel.recommendList(false, nextPage, 20);

    if (_viewModel.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }
}
