import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/mine_models.dart';
import '../viewmodels/month_pay_viewmodel.dart';
import '../viewmodels/wallet_viewmodel.dart';

class BackUpMoneyPage extends StatefulWidget {
  const BackUpMoneyPage({super.key});

  @override
  State<BackUpMoneyPage> createState() => _BackUpMoneyPageState();
}

class _BackUpMoneyPageState extends State<BackUpMoneyPage> {
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _alipayController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _agreed = true;
  String? _purpose;

  final List<String> _purposeList = const [
    '装修建材',
    '旅游消费',
    '家具家电',
    '婚庆服务',
    '百货消费',
  ];

  MineCreditEntity? _mineCredit;
  double _handlingFee = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMineCredit();
    });
    _moneyController.addListener(_recalcFee);
  }

  @override
  void dispose() {
    _moneyController
      ..removeListener(_recalcFee)
      ..dispose();
    _alipayController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadMineCredit() async {
    final vm = Provider.of<MonthPayViewModel>(context, listen: false);
    await vm.fetchMineCredit(showLoading: false);
    if (!mounted) return;
    final credit = vm.mineCredit;
    final defaultMoney = (credit?.usableCreditAmount ?? 0).toString();
    setState(() {
      _mineCredit = credit;
      _moneyController.text = _normalizeMoney(defaultMoney);
      _recalcFee();
    });
  }

  void _recalcFee() {
    final money = double.tryParse(_moneyController.text.trim()) ?? 0;
    final moneyRate = (_mineCredit?.moneyRate ?? 0) / 100;
    final fee = money * moneyRate;
    final minFee = _mineCredit?.pettyMinMoney ?? 0;
    setState(() {
      _handlingFee = fee < minFee ? minFee : fee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHintCard(),
                    _buildMoneyCard(),
                    _buildAccountCard(),
                    _buildPurposeCard(),
                    _buildAgreementRow(),
                    _buildSubmit(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 52.h,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset('assets/images/icon_back.webp', width: 12.w, height: 18.h),
              ),
            ),
          ),
          Text('备用金', style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _buildHintCard() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          Image.asset(
            'assets/images/icon_backup_left.webp',
            width: 13.w,
            height: 13.w,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text('可用于短期消费周转，按月付账单还款', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666))),
          ),
          Image.asset(
            'assets/images/icon_backup_right.webp',
            width: 7.w,
            height: 11.h,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyCard() {
    final repaymentDay = _mineCredit?.repaymentDate ?? '-';
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('￥', style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 3.w),
              SizedBox(
                width: 180.w,
                child: TextField(
                  controller: _moneyController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 44.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                ),
              ),
              Image.asset(
                'assets/images/icon_backup_edit.webp',
                width: 12.w,
                height: 12.w,
                fit: BoxFit.fill,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text('每月$repaymentDay号还款', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF0D86EC))),
          SizedBox(height: 30.h),
          _detailRow('还款方式', '月付账单'),
          SizedBox(height: 20.h),
          _detailRow('取现费用', '￥${_handlingFee.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      padding: EdgeInsets.fromLTRB(11.w, 20.h, 11.w, 16.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('收款账户', style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A)))),
              Image.asset('assets/images/app_with_draw_alipay.png', width: 16.w, height: 16.w),
              SizedBox(width: 7.w),
              Text('支付宝', style: TextStyle(fontSize: 15.sp, color: const Color(0xFF1A1A1A))),
              SizedBox(width: 12.w),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _alipayController,
            decoration: _inputDecoration('请输入支付宝账号'),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _nameController,
            decoration: _inputDecoration('请输入真实姓名'),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeCard() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          Text('资金用途', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
          const Spacer(),
          GestureDetector(
            onTap: _selectPurpose,
            child: Container(
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(14.r)),
              child: Row(
                children: [
                  Text(_purpose ?? '请选择', style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666))),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward_ios, size: 11.sp, color: const Color(0xFF666666)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Image.asset(
              _agreed ? 'assets/images/ic_select.png' : 'assets/images/ic_un_select.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '已阅读并同意《取现合同》与《相关协议》',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF888888)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmit() {
    return Container(
      margin: EdgeInsets.fromLTRB(52.w, 20.h, 52.w, 20.h),
      width: double.infinity,
      height: 49.h,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFF3530),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
        ),
        onPressed: _onSubmit,
        child: Text('确认取现', style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)))),
        Text(value, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333))),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFAFAFAF)),
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
    );
  }

  String _normalizeMoney(String value) {
    final parsed = double.tryParse(value) ?? 0;
    if (parsed == parsed.toInt()) {
      return parsed.toInt().toString();
    }
    return parsed.toStringAsFixed(2);
  }

  Future<void> _selectPurpose() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _purposeList.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final value = _purposeList[index];
              return ListTile(
                title: Text(value),
                onTap: () => Navigator.of(context).pop(value),
              );
            },
          ),
        );
      },
    );
    if (selected != null) {
      setState(() => _purpose = selected);
    }
  }

  Future<void> _onSubmit() async {
    final account = _alipayController.text.trim();
    final name = _nameController.text.trim();
    final money = _moneyController.text.trim();
    final credit = _mineCredit;

    if (!_agreed) {
      LoadingManager.instance.showToast('请勾选同意协议');
      return;
    }
    if (money.isEmpty) {
      LoadingManager.instance.showToast('请输入提款金额');
      return;
    }
    if (account.isEmpty) {
      LoadingManager.instance.showToast('请输入支付宝账号');
      return;
    }
    if (name.isEmpty) {
      LoadingManager.instance.showToast('请输入真实姓名');
      return;
    }

    final moneyValue = double.tryParse(money) ?? 0;
    if (moneyValue < 100) {
      LoadingManager.instance.showToast('取现金额不能低于100');
      return;
    }
    if (credit != null && moneyValue > (credit.usableCreditAmount ?? 0)) {
      LoadingManager.instance.showToast('可用授信额度不足');
      return;
    }

    final walletVm = Provider.of<WalletViewModel>(context, listen: false);
    final result = await walletVm.submitBackUpMoney(
      account: account,
      realName: name,
      money: money,
      passWord: '',
      purpose: _purpose,
    );
    if (!mounted) return;

    if (result?.status == '1') {
      context.nav.push(
        RoutePaths.other.backUpSuccess,
        arguments: {
          'alipayCode': result?.alipayCode,
          'extractPrice': result?.extractPrice,
          'handlingFee': result?.handlingFee,
          'purpose': result?.purpose,
          'name': name,
          'money': money,
        },
      );
      Navigator.of(context).pop();
      return;
    }
    if (result?.status == '0') {
      LoadingManager.instance.showToast('取现申请已提交，正在审核中');
      return;
    }
    LoadingManager.instance.showToast('取现失败');
  }
}
