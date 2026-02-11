import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../app/utils/string_utils.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';
import '../../home/models/user_models.dart';

class PhoneRecycleMsgPage extends StatefulWidget {
  const PhoneRecycleMsgPage({super.key});

  @override
  State<PhoneRecycleMsgPage> createState() => _PhoneRecycleMsgPageState();
}

class _PhoneRecycleMsgPageState extends State<PhoneRecycleMsgPage> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _memoryController = TextEditingController();
  final TextEditingController _channelController = TextEditingController();

  @override
  void dispose() {
    _brandController.dispose();
    _typeController.dispose();
    _colorController.dispose();
    _memoryController.dispose();
    _channelController.dispose();
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
                  _buildInputRow('品牌', '请输入品牌', _brandController),
                  _buildDivider(),
                  _buildInputRow('型号', '请输入型号', _typeController),
                  _buildDivider(),
                  _buildInputRow('颜色', '请输入颜色', _colorController),
                  _buildDivider(),
                  _buildInputRow('机身内存', '请输入机身内存', _memoryController),
                  _buildDivider(),
                  _buildInputRow('购买渠道', '请输入渠道（如大陆、港版）', _channelController),
                  SizedBox(height: 50.h),
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
                '询价详情',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onLookOrder,
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Text(
                '查看订单',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFFFF3530),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      height: 62.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: 110.w, right: 12.w),
      color: const Color(0xFFE6E6E6),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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
            '提交',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _onLookOrder() {
    context.nav.push(
      RoutePaths.other.recycleOrderList,
      arguments: {'recycleType': '2'},
    );
  }

  Future<void> _onSubmit() async {
    if (StringUtils.isEmpty(_brandController.text)) {
      LoadingManager.instance.showToast('请输入手机品牌');
      return;
    }
    if (StringUtils.isEmpty(_typeController.text)) {
      LoadingManager.instance.showToast('请填写手机型号');
      return;
    }
    if (StringUtils.isEmpty(_colorController.text)) {
      LoadingManager.instance.showToast('请填写手机颜色');
      return;
    }
    if (StringUtils.isEmpty(_memoryController.text)) {
      LoadingManager.instance.showToast('请填写机身内存');
      return;
    }
    if (StringUtils.isEmpty(_channelController.text)) {
      LoadingManager.instance.showToast('请填写购买渠道');
      return;
    }

    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }

    UserApi.getUserCreditDetail(
      onSuccess: (credit) async {
        await _navigateByCreditDetail(credit);
      },
      onError: (exception) {
        LoadingManager.instance.showToast('获取信息失败');
      },
    );
  }

  Future<void> _navigateByCreditDetail(UserCreditEntity? credit) async {
    if (credit?.hasApply == true) {
      if (credit?.status == 2) {
        context.nav.push(RoutePaths.other.phoneRecycleOrder);
        return;
      }
      if (credit?.status == 1) {
        context.nav.push(RoutePaths.other.examineIng);
        return;
      }
      if (credit?.status == 3) {
        context.nav.push(
          RoutePaths.other.examineFail,
          arguments: {'nextApplyTime': credit?.nextApplyTime},
        );
        return;
      }
      final hasAuth = await _hasAuthentication();
      if (hasAuth) {
        context.nav.push(RoutePaths.other.supplementMessage);
      } else {
        context.nav.push(
          RoutePaths.other.applyQuota,
          arguments: {'hasApply': true},
        );
      }
      return;
    }
    context.nav.push(
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
