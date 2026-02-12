import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../app/utils/string_utils.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';
import '../../home/models/user_models.dart';
import '../models/order_models.dart';
import '../viewmodels/gold_viewmodel.dart';
import '../widgets/gold_recycle_desc_dialog.dart';

class ShopRecyclePage extends StatefulWidget {
  final String? id;
  final String? recyclePrice;
  final String? expressNumber;
  final String? orderInfoId;

  const ShopRecyclePage({
    super.key,
    this.id,
    this.recyclePrice,
    this.expressNumber,
    this.orderInfoId,
  });

  @override
  State<ShopRecyclePage> createState() => _ShopRecyclePageState();
}

class _ShopRecyclePageState extends State<ShopRecyclePage> {
  late final GoldViewModel _viewModel;
  final TextEditingController _alipayNameController = TextEditingController();
  final TextEditingController _expressController = TextEditingController();

  bool _protocolAgreed = false;
  bool _showModeSwitch = false;
  bool _selfMode = false;

  GoldEntity? _selectedOrder;
  String? _orderInfoId;
  String _recyclePrice = '0.00';

  double _goldPrice = 683.35;
  int _goldWeight = 1;

  @override
  void initState() {
    super.initState();
    _viewModel = GoldViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _orderInfoId = widget.orderInfoId;
    _recyclePrice = widget.recyclePrice ?? '0.00';
    if (!StringUtils.isEmpty(widget.expressNumber)) {
      _expressController.text = widget.expressNumber ?? '';
    }
    UserProvider.updateUserInfo().then((_) {
      if (mounted) setState(() {});
    });
    _viewModel.fetchGoldPrice(showLoading: false);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _alipayNameController.dispose();
    _expressController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    final priceStr = _viewModel.goldPrice;
    if (priceStr != null && priceStr.isNotEmpty) {
      final parsed = double.tryParse(priceStr) ?? _goldPrice;
      if (parsed != _goldPrice && mounted) {
        setState(() {
          _goldPrice = parsed;
        });
      }
    }
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
                    child: Column(
                      children: [
                        _buildInputRow(
                          label: '回收黄金',
                          hint: '请输入商品克数',
                          keyboardType: TextInputType.number,
                        ),
                        _buildDivider(start: 285.w),
                      ],
                    ),
                  ),
                  _buildGoldRecycleHeader(),
                  _buildSelectOrder(),
                  Container(
                    height: 12.h,
                    color: const Color(0xFFF7F9FC),
                  ),
                  _buildRow(
                    label: '回收价格',
                    alignment: Alignment.centerRight,
                    expandLabel: true,
                    child: Text(
                      _recyclePrice,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Visibility(
                    visible: _showModeSwitch,
                    child: _buildModeSwitch(),
                  ),
                  Visibility(
                    visible: _showModeSwitch && _selfMode,
                    child: _buildSelfInfo(),
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
                '黄金回收',
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

  Widget _buildGoldRecycleHeader() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 60.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFBF8C4D), Color(0xFFFFDFA0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.r),
              bottomRight: Radius.circular(32.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_gold_recycle_step1.png',
                      width: 36.w,
                      height: 36.w,
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/icon_gold_recycle_line.png',
                          width: 28.w,
                          height: 28.w,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/icon_gold_recycle_step2.png',
                      width: 36.w,
                      height: 36.w,
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/icon_gold_recycle_line.png',
                          width: 28.w,
                          height: 28.w,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/icon_gold_recycle_step3.png',
                      width: 36.w,
                      height: 36.w,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '锁定回收价',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '寄卖行回收确认',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '回购完成',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '填写信息',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '上传资料填写信息单',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '回收结算',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF5F0),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '共有0个订单待回购',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFDCB783),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _onLookOrder,
                      child: Container(
                        width: 74.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5C286),
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                        child: Text(
                          '查看订单',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Visibility(
          visible: false,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              children: [
                Text(
                  '实时金价',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _goldPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0xFFDCB783),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '元/克',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26.h),
                Container(
                  height: 50.h,
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBF8C4D), Color(0xFFFFDFA0)],
                    ),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '$_goldWeight 克',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (_goldWeight <= 1) return;
                            setState(() {
                              _goldWeight -= 1;
                            });
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            margin: EdgeInsets.only(left: 5.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(99.r),
                            ),
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: const Color(0xFFF59A23),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _goldWeight += 1;
                            });
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            margin: EdgeInsets.only(right: 5.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(99.r),
                            ),
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: const Color(0xFFF59A23),
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
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                title: '商品介绍（请认真阅读)',
                desc: '商品介绍',
                onTap: () => showGoldRecycleDescDialog(context, 1),
              ),
              _infoDivider(),
              _buildInfoRow(
                title: '费用信息',
                desc: '工费 | 服务费 | 手续费',
                onTap: () => showGoldRecycleDescDialog(context, 2),
              ),
              _infoDivider(),
              _buildInfoRow(
                title: '回购规则',
                desc: '交易规则 | 回购规则',
                onTap: () => showGoldRecycleDescDialog(context, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(width: 6.w),
                Image.asset(
                  'assets/images/icon_right_arrow.png',
                  width: 12.w,
                  height: 12.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoDivider() {
    return Container(
      height: 1.h,
      color: const Color(0xFFF2F2F2),
    );
  }

  Widget _buildSelectOrder() {
    return GestureDetector(
      onTap: _onSelectOrder,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        margin: EdgeInsets.only(top: 10.h),
        color: Colors.white,
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
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 37.w,
        height: 37.w,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          'assets/images/shape_recycle_logo.webp',
          width: 37.w,
          height: 37.w,
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required Widget child,
    Alignment alignment = Alignment.centerLeft,
    bool expandLabel = false,
  }) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.white,
      child: Row(
        children: [
          expandLabel
              ? Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                )
              : SizedBox(
                  width: 100.w,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
          expandLabel
              ? Align(alignment: alignment, child: child)
              : Expanded(child: Align(alignment: alignment, child: child)),
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hasValue ? phone : '请填写账号',
          style: TextStyle(
            fontSize: 15.sp,
            color: hasValue ? const Color(0xFF333333) : const Color(0xFFB3B3B3),
          ),
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
            child: GestureDetector(
              onTap: () => setState(() => _selfMode = false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selfMode
                      ? Colors.white
                      : const Color(0x19FF3530),
                  borderRadius: BorderRadius.circular(19.r),
                ),
                child: Text(
                  '平台回收',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _selfMode
                        ? const Color(0xFF333333)
                        : const Color(0xFFFF3530),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selfMode = true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selfMode
                      ? const Color(0x19FF3530)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(19.r),
                ),
                child: Text(
                  '自寄实物',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _selfMode
                        ? const Color(0xFFFF3530)
                        : const Color(0xFF333333),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfInfo() {
    return Column(
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
          controller: _expressController,
        ),
      ],
    );
  }

  Widget _buildInputRow({
    required String label,
    required String hint,
    TextEditingController? controller,
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
              controller: controller,
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
      arguments: {'recycleType': '1'},
    );
    if (result.success && result.data != null) {
      setState(() {
        _selectedOrder = result.data;
        _orderInfoId = result.data?.orderInfoId;
        _recyclePrice = result.data?.recyclePrice ?? '0.00';
      });
    }
  }

  void _onLookOrder() {
    NavigatorService.instance.push(RoutePaths.other.recycleOrderList, arguments: {
      'recycleType': '1',
    });
  }

  void _onProtocolTap() {
    NavigatorService.instance.push(RoutePaths.other.webview, arguments: {
      'url': AppConstants.userRecycleGoldProtocolUrl,
      'title': '回收协议',
    });
  }

  Future<void> _onSubmit() async {
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
    await _viewModel.fetchUserCreditDetail(showLoading: true);
    await _navigateByCreditDetail(
      _viewModel.userCredit,
      _alipayNameController.text,
    );
  }

  Future<void> _navigateByCreditDetail(
    UserCreditEntity? credit,
    String alipayName,
  ) async {
    if (credit?.hasApply == true) {
      if (credit?.status == 2) {
        _viewModel.phoneRecycleOrder(
          recycleType: '1',
          alipayAccount: UserProvider.getUserPhone(),
          realName: alipayName,
          orderInfoId: _orderInfoId ?? '',
          onSuccess: (data) {
            BoostNavigator.instance.pushReplacement(
              RoutePaths.other.shopRecycleDetail.path,
              arguments: {
                'id': (data?.id ?? 0).toString(),
                'pageType': 1,
                'pageSource': 1,
              },
            );
          },
        );
        return;
      }
      if (credit?.status == 1) {
        NavigatorService.instance.push(RoutePaths.other.examineIng);
        return;
      }
      if (credit?.status == 3) {
        NavigatorService.instance.push(RoutePaths.other.examineFail, arguments: {
          'nextApplyTime': credit?.nextApplyTime,
        });
        return;
      }
      final hasAuth = await _hasAuthentication();
      if (hasAuth) {
        NavigatorService.instance.push(RoutePaths.other.supplementMessage);
      } else {
        NavigatorService.instance.push(
          RoutePaths.other.applyQuota,
          arguments: {'hasApply': true},
        );
      }
      return;
    }
    NavigatorService.instance.push(
      RoutePaths.other.applyQuota,
      arguments: {'hasApply': false},
    );
  }

  Future<bool> _hasAuthentication() async {
    UserInfoEntity? userInfo;
    await UserApi.getUserInfo(
      onSuccess: (data) {
        userInfo = data;
      },
    );
    return userInfo?.hasAuthentication == true;
  }
}
