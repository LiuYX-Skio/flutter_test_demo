import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/utils/string_utils.dart';
import '../viewmodels/wallet_viewmodel.dart';

class WithDrawPage extends StatefulWidget {
  const WithDrawPage({super.key});

  @override
  State<WithDrawPage> createState() => _WithDrawPageState();
}

class _WithDrawPageState extends State<WithDrawPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  String _withDrawMoney = '0.00';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<WalletViewModel>(context, listen: false);
      viewModel.fetchWithDrawUserInfo().then((_) {
        final info = viewModel.withDrawUserInfo;
        final money = StringUtils.getNotNullParam(info?.nowMoney);
        setState(() {
          _withDrawMoney = money.isEmpty ? '0.00' : money;
        });
      });
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    _nameController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: Stack(
        children: [
          Container(
            height: 270.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3F4F5), Color(0xFFFB532E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 44.h),
              _buildTopBar(),
              SizedBox(height: 22.h),
              _buildAccountCard(),
              SizedBox(height: 10.h),
              _buildMoneyCard(),
              const Spacer(),
              _buildBottomAction(),
            ],
          ),
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
          Text(
            '零钱取现',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '取现至',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/app_with_draw_alipay.png',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 7.w),
                Text(
                  '支付宝',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(height: 1.h, color: Colors.transparent),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: TextField(
              controller: _accountController,
              decoration: InputDecoration(
                hintText: '请输入支付宝账号',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFAFAFAF),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              bottom: 16.h,
            ),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '请输入支付宝真实姓名',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFAFAFAF),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Text(
              '取现金额',
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Row(
              children: [
                Text(
                  '￥',
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: TextField(
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _onAllMoney,
                  child: Text(
                    '全部取现',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFFFB532E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            height: 1.h,
            color: const Color(0xFFEBEBEB),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '可取现金额 ￥$_withDrawMoney',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFA6A6A6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Column(
        children: [
          Text(
            '温馨提示:取现申请发起后，预计在3个工作日内日到账。',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999)),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                  '确认取现',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAllMoney() {
    _moneyController.text = _withDrawMoney;
  }

  void _onSubmit() {
    final account = _accountController.text.trim();
    final name = _nameController.text.trim();
    final money = _moneyController.text.trim();
    if (account.isEmpty) {
      LoadingManager.instance.showToast('请输入取现账号');
      return;
    }
    if (name.isEmpty) {
      LoadingManager.instance.showToast('请输入真实姓名');
      return;
    }
    if (money.isEmpty) {
      LoadingManager.instance.showToast('请输入取现金额');
      return;
    }

    final viewModel = Provider.of<WalletViewModel>(context, listen: false);
    viewModel.submitWithDraw(
      account: account,
      realName: name,
      money: money,
      passWord: '',
      onSuccess: () {
        LoadingManager.instance.showToast('取现申请已提交');
        Navigator.of(context).pop();
      },
    );
  }
}
