import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../app/utils/string_utils.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/order_models.dart';
import '../viewmodels/gold_viewmodel.dart';

class PhoneRecycleOrderPage extends StatefulWidget {
  const PhoneRecycleOrderPage({super.key});

  @override
  State<PhoneRecycleOrderPage> createState() => _PhoneRecycleOrderPageState();
}

class _PhoneRecycleOrderPageState extends State<PhoneRecycleOrderPage> {
  late final GoldViewModel _viewModel;
  final TextEditingController _alipayNameController = TextEditingController();

  bool _protocolAgreed = false;
  GoldEntity? _selectedOrder;
  String? _orderInfoId;

  @override
  void initState() {
    super.initState();
    _viewModel = GoldViewModel();
    UserProvider.updateUserInfo().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _alipayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Visibility(
                    visible: false,
                    child: _buildModeSwitch(),
                  ),
                  _buildSelfInfo(),
                  _buildSelectOrder(),
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
                  _buildDivider(start: 110.w),
                  _buildTipRow(),
                  _buildDivider(start: 110.w),
                  _buildAccountRow(),
                  _buildDivider(start: 110.w),
                  _buildNameInputRow(),
                  _buildProtocolRow(),
                  _buildSubmitButton(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
                '手机回收',
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

  Widget _buildSelectOrder() {
    return GestureDetector(
      onTap: _onSelectOrder,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: _selectedOrder == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/recycle_add.webp',
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(width: 9.w),
                  Text(
                    '选择购物订单',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF2F89EE),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    _buildSelectedImage(),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Text(
                        _selectedOrder?.productName ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    final imageUrl = _selectedOrder?.image ?? '';
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/shape_recycle_logo.webp',
        width: 37.w,
        height: 37.w,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Image.network(
        imageUrl,
        width: 37.w,
        height: 37.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Image.asset(
            'assets/images/shape_recycle_logo.webp',
            width: 37.w,
            height: 37.w,
          );
        },
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

  Widget _buildTipRow() {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Text(
        '提示：为规范风险，收款账号必须本人商城手机号码',
        style: TextStyle(
          fontSize: 15.sp,
          color: const Color(0xFFFF3530),
        ),
      ),
    );
  }

  Widget _buildAccountRow() {
    final phone = UserProvider.getUserPhone();
    final hasValue = phone.isNotEmpty;
    return _buildRow(
      label: '账号',
      child: Text(
        hasValue ? phone : '请填写账号',
        style: TextStyle(
          fontSize: 15.sp,
          color: hasValue ? const Color(0xFF333333) : const Color(0xFFB3B3B3),
        ),
      ),
    );
  }

  Widget _buildNameInputRow() {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '姓名',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _alipayNameController,
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: '请填写姓名',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFB3B3B3),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolRow() {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _protocolAgreed = !_protocolAgreed;
              });
            },
            child: Image.asset(
              _protocolAgreed
                  ? 'assets/images/ic_select.png'
                  : 'assets/images/ic_un_select.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '已阅读并同意协议',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: _onProtocolTap,
                      child: Text(
                        '《回收协议》',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFFF3530),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: const Color(0xFFF7F9FC),
      child: SizedBox(
        width: double.infinity,
        height: 49.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFF3530),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.r),
            ),
          ),
          onPressed: _onSubmit,
          child: Text(
            '提交',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSwitch() {
    return Container(
      width: 205.w,
      height: 37.h,
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x19FF3530),
                borderRadius: BorderRadius.circular(19.r),
              ),
              child: Text(
                '平台回收',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFFF3530),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19.r),
              ),
              child: Text(
                '自寄实物',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfInfo() {
    return Visibility(
      visible: false,
      child: Column(
        children: [
          _buildInputRow(label: '寄件人', hint: '请填写寄件人真实姓名'),
          _buildDivider(start: 110.w),
          _buildInputRow(
            label: '联系电话',
            hint: '请填写手机号',
            keyboardType: TextInputType.phone,
          ),
          _buildDivider(start: 110.w),
          _buildInputRow(
            label: '快递单号',
            hint: '请填写快递单号',
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required String hint,
    TextInputType? keyboardType,
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
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFB3B3B3),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({required double start}) {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: start, right: 12.w),
      color: const Color(0xFFE6E6E6),
    );
  }

  Future<void> _onSelectOrder() async {
    final result = await NavigatorService.instance.push<GoldEntity>(
      RoutePaths.other.shopCanRecycleList,
      arguments: {'recycleType': '2'},
    );
    if (result.success && result.data != null) {
      setState(() {
        _selectedOrder = result.data;
        _orderInfoId = result.data?.orderInfoId;
      });
    }
  }

  void _onProtocolTap() {
    NavigatorService.instance.push(RoutePaths.other.webview, arguments: {
      'url': AppConstants.userRecyclePhoneProtocolUrl,
      'title': '回收协议',
    });
  }

  void _onSubmit() {
    if (StringUtils.isEmpty(_orderInfoId)) {
      LoadingManager.instance.showToast('请选择购物订单');
      return;
    }
    if (StringUtils.isEmpty(_alipayNameController.text)) {
      LoadingManager.instance.showToast('请填写支付宝姓名');
      return;
    }
    if (!_protocolAgreed) {
      LoadingManager.instance.showToast('请勾选协议');
      return;
    }
    _viewModel.phoneRecycleOrder(
      recycleType: '2',
      alipayAccount: UserProvider.getUserPhone(),
      realName: _alipayNameController.text,
      orderInfoId: _orderInfoId ?? '',
      onSuccess: (data) {
        BoostNavigator.instance.pushReplacement(
          RoutePaths.other.shopRecycleDetail.path,
          arguments: {
            'id': (data?.id ?? 0).toString(),
            'pageType': 2,
            'pageSource': 1,
          },
        );
      },
    );
  }
}
