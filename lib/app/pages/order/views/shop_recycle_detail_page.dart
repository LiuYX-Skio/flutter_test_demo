import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:provider/provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/gold_viewmodel.dart';

class ShopRecycleDetailPage extends StatefulWidget {
  final String id;
  final int pageType;
  final int pageSource;
  final bool isCanCancelOrder;

  const ShopRecycleDetailPage({
    super.key,
    required this.id,
    this.pageType = 1,
    this.pageSource = 0,
    this.isCanCancelOrder = true,
  });

  @override
  State<ShopRecycleDetailPage> createState() => _ShopRecycleDetailPageState();
}

class _ShopRecycleDetailPageState extends State<ShopRecycleDetailPage> {
  late final GoldViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GoldViewModel();
    _viewModel.fetchRecycleOrderDetail(widget.id);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 44.h),
            _buildTopBar(),
            Expanded(
              child: Consumer<GoldViewModel>(
                builder: (context, viewModel, child) {
                  final detail = viewModel.detail;
                  final hasPrice =
                      (detail?.recyclePrice ?? '').trim().isNotEmpty;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 12.h,
                          color: const Color(0xFFF7F9FC),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                          color: Colors.white,
                          child: Row(
                            children: [
                              _buildDetailImage(
                                detail?.orderInfoResponse?.image ?? '',
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: Text(
                                  detail?.orderInfoResponse?.storeName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 12.h,
                          color: const Color(0xFFF7F9FC),
                        ),
                        _buildRow(
                          label: '回收价格',
                          child: hasPrice
                              ? Text(
                                  detail?.recyclePrice ?? '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          height: 12.h,
                          color: const Color(0xFFF7F9FC),
                        ),
                        Visibility(
                          visible: false,
                          child: Column(
                            children: [
                              _buildRow(
                                label: '寄件人',
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                              _buildDivider(),
                              _buildRow(
                                label: '联系电话',
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                              _buildDivider(),
                              _buildRow(
                                label: '快递单号',
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 12.h,
                          color: const Color(0xFFF7F9FC),
                        ),
                        _buildRow(
                          label: '收款账号',
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/icon_recycle_alipay.webp',
                                width: 16.w,
                                height: 14.h,
                              ),
                              SizedBox(width: 7.w),
                              Text(
                                '支付宝',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildDivider(),
                        _buildRow(
                          label: '账号',
                          child: Text(
                            detail?.alipayAccount ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildRow(
                          label: '姓名',
                          child: Text(
                            detail?.realName ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        Container(
                          color: const Color(0xFFF7F9FC),
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(height: 50.h),
                              Visibility(
                                visible: widget.isCanCancelOrder,
                                child: GestureDetector(
                                  onTap: _onCancelOrder,
                                  child: Container(
                                    width: 146.w,
                                    height: 41.h,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 30.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(21.r),
                                      border: Border.all(
                                        color: const Color(0xFFFF362F),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Text(
                                      '取消订单',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: const Color(0xFFFF362F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: _onBack,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 11.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '订单详情',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required Widget child,
  }) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          Expanded(child: Align(alignment: Alignment.centerLeft, child: child)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: 100.w, right: 12.w),
      color: const Color(0xFFE6E6E6),
    );
  }

  Widget _buildDetailImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/shape_recycle_logo.webp',
        width: 37.w,
        height: 37.w,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 37.w,
        height: 37.w,
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset(
          'assets/images/shape_recycle_logo.webp',
          width: 37.w,
          height: 37.w,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/shape_recycle_logo.webp',
          width: 37.w,
          height: 37.w,
        ),
      ),
    );
  }

  void _onBack() {
    if (widget.pageSource == 1) {
      BoostNavigator.instance.pushReplacement(
        RoutePaths.other.recycleOrderList.path,
        arguments: {'recycleType': widget.pageType.toString()},
      );
      return;
    }
    context.nav.pop();
  }

  void _onCancelOrder() {
    if (widget.id.isEmpty) return;
    _viewModel.cancelRecycleOrder(
      id: widget.id,
      onSuccess: (_) {
        context.nav.pop();
      },
    );
  }
}
