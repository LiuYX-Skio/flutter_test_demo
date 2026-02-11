import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

class RecallMoneyPage extends StatefulWidget {
  const RecallMoneyPage({super.key, required this.args});

  final Map<String, dynamic> args;

  @override
  State<RecallMoneyPage> createState() => _RecallMoneyPageState();
}

class _RecallMoneyPageState extends State<RecallMoneyPage> {
  late double minimumRepayment;
  late String? billMonthItem;
  late String? billMonth;
  late String? overdueRepaymentRate;
  late int exceedDay;
  late double totalMoney;

  bool _isMinSelected = false;
  final TextEditingController _moneyController = TextEditingController();
  final FocusNode _moneyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    minimumRepayment = (widget.args['minimumRepayment'] ?? 0.0) * 1.0;
    billMonthItem = widget.args['billMonthItem'] as String?;
    billMonth = widget.args['billMonth'] as String?;
    overdueRepaymentRate = widget.args['overdueRepaymentRate'] as String?;
    exceedDay = (widget.args['exceedDay'] ?? 0) as int;
    totalMoney = (widget.args['totalMoney'] ?? 0.0) * 1.0;

    _moneyController.text = totalMoney.toString();
  }

  @override
  void dispose() {
    _moneyController.dispose();
    _moneyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showMinSelect = exceedDay > 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          SizedBox(height: 31.h),
          _buildMoneyInputCard(),
          SizedBox(height: 10.h),
          if (showMinSelect) _buildMinSelectCard(),
          const Spacer(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/icon_back.webp',
              width: 12.w,
              height: 18.h,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${billMonth ?? ''}月账单还款',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '剩余应还$totalMoney元',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildMoneyInputCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h, bottom: 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '立即还款（元）',
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _moneyController,
                  focusNode: _moneyFocusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 33.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _focusMoneyInput,
                child: Text(
                  '修改',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFFFB532E),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinSelectCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isMinSelected = !_isMinSelected),
            child: Image.asset(
              _isMinSelected
                  ? 'assets/images/icon_recall_select.webp'
                  : 'assets/images/icon_recall_unselect.webp',
              width: 20.w,
              height: 20.w,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '分期还款,先还最低,下个月再还',
                  style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A)),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '剩余随时还,协商找客服',
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 13.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4046),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        overdueRepaymentRate == null || overdueRepaymentRate!.isEmpty
                            ? '日利息'
                            : '日利息$overdueRepaymentRate%',
                        style: TextStyle(fontSize: 9.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            minimumRepayment.toString(),
            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 50.h),
      height: 49.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFF3530),
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: TextButton(
        onPressed: _onConfirm,
        child: Text(
          '确认还款',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      ),
    );
  }

  void _focusMoneyInput() {
    FocusScope.of(context).requestFocus(_moneyFocusNode);
  }

  void _onConfirm() {
    final input = double.tryParse(_moneyController.text) ?? 0.0;
    final recallMoney = _isMinSelected ? minimumRepayment : input;

    if (!_isMinSelected && input > totalMoney) {
      _showToast('还款金额不能高于$totalMoney元');
      return;
    }
    if (recallMoney < 1) {
      _showToast('还款金额最低不能小于1元');
      return;
    }
    if (!_isMinSelected && input < minimumRepayment) {
      _showToast('最低还款金额不能少于$minimumRepayment 元');
      return;
    }

    NavigatorService.instance.push(
      RoutePaths.other.shopPay,
      arguments: {
        'orderNo': billMonthItem,
        'payMoney': recallMoney.toString(),
        'viewType': 2,
      },
    );
    Navigator.of(context).pop();
  }

  void _showToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1)),
    );
  }
}
