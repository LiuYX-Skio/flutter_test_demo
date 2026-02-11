import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../app/utils/string_utils.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';

class MineWalletPage extends StatefulWidget {
  const MineWalletPage({super.key});

  @override
  State<MineWalletPage> createState() => _MineWalletPageState();
}

class _MineWalletPageState extends State<MineWalletPage> {
  String _money = '';

  @override
  void initState() {
    super.initState();
    _initMoney();
  }

  Future<void> _initMoney() async {
    await UserProvider.updateUserInfo();
    _money = StringUtils.getNotNullParam(UserProvider.getUserMoney());
    if (_money.isEmpty) {
      _money = '0.00';
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5),
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(),
          Container(height: 12.h, color: Colors.white),
          _buildWalletCard(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 12.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '我的零钱',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      height: 110.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/icon_wallet.webp'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 19.w,
            top: 26.h,
            child: Text(
              '零钱（元）',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0x99FFFFFF),
              ),
            ),
          ),
          Positioned(
            left: 21.w,
            top: 52.h,
            child: Text(
              _money,
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 4.h,
            child: const SizedBox.shrink(),
          ),
          Positioned(
            right: 0,
            bottom: 4.h,
            child: const SizedBox.shrink(),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _onWithdraw() {
    context.nav.push(RoutePaths.user.withdraw);
  }

  void _onWithdrawRecord() {
    context.nav.push(RoutePaths.user.withdrawRecord);
  }

  void _onCharge() {
    context.nav.push(RoutePaths.user.charge);
  }
}
