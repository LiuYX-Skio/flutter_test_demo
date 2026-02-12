import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';

class AccountSafeDetailPage extends StatefulWidget {
  const AccountSafeDetailPage({super.key});

  @override
  State<AccountSafeDetailPage> createState() => _AccountSafeDetailPageState();
}

class _AccountSafeDetailPageState extends State<AccountSafeDetailPage> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  Image.asset(
                    'assets/images/icon_warn.webp',
                    width: 47.w,
                    height: 42.h,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '注销账号将永久失效且不可恢复\n并将放弃以下权益资产与服务',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  _buildContentCard(),
                  SizedBox(height: 30.h),
                  _buildProtocolRow(),
                  SizedBox(height: 21.h),
                  _buildSubmitButton(),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
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
                '账户与安全',
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

  Widget _buildContentCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 23.h),
          Text(
            '您的所有交易记录将被清空，请确保所有交易已完结且无纠纷，账号注销后因历史交易可能产生的退换货、维权相关的资金退回等权益将视作自动放弃。',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF666666),
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '注销前，我们将进行以下验证：',
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFFFF3530),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          _buildSectionTitle('1、账号近期不存在交易'),
          _buildSectionDesc('您的账号无未完成订单、无已完成但未满15天订单等。'),
          _buildSectionTitle('2、账号相关财产权益已结清'),
          _buildSectionDesc('您的账号不存在购物金余额、保证金等账户余额。'),
          _buildSectionTitle('3、账号下不存在尚未注销的商品'),
          _buildSectionDesc('基于相关法律法规要求及商品经营相关交易安全需要，您需先完成商品注销。'),
          _buildSectionTitle('4、账号不存在未完结的服务'),
          _buildSectionDesc('您的账号不存在尚未完结的服务市场订购服务、代扣服务等。'),
          SizedBox(height: 28.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildSectionDesc(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF666666),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildProtocolRow() {
    return GestureDetector(
      onTap: () => setState(() => _agreed = !_agreed),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _agreed
                ? 'assets/images/ic_select.png'
                : 'assets/images/ic_un_select.png',
            width: 15.w,
            height: 15.w,
          ),
          SizedBox(width: 11.w),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF888888)),
              children: [
                const TextSpan(text: '已阅读并同意一协议'),
                TextSpan(
                  text: '《用户协议》',
                  style: const TextStyle(color: Color(0xFFFF3530)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.nav.push(
                        RoutePaths.other.webview,
                        arguments: {
                          'url': AppConstants.userProtocolUrl,
                          'title': AppConstants.userProtocolTitle,
                        },
                      );
                    },
                ),
                TextSpan(
                  text: '《隐私协议》',
                  style: const TextStyle(color: Color(0xFFFF3530)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.nav.push(
                        RoutePaths.other.webview,
                        arguments: {
                          'url': AppConstants.privacyProtocolUrl,
                          'title': AppConstants.privacyProtocolTitle,
                        },
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: SizedBox(
        width: double.infinity,
        height: 49.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFF3530),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          onPressed: _onSubmit,
          child: Text(
            '注销',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_agreed) {
      LoadingManager.instance.showToast('请勾选同意协议');
      return;
    }
    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }
    UserApi.cancelAccount(
      onSuccess: (_) async {
        await UserProvider.clearUserInfo();
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop();
        context.nav.push(RoutePaths.auth.login);
      },
    );
  }
}
