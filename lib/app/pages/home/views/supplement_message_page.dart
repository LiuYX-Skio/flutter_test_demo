import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/auth_flow_viewmodel.dart';

class SupplementMessagePage extends StatefulWidget {
  final bool isNeedClose;

  const SupplementMessagePage({
    super.key,
    this.isNeedClose = false,
  });

  @override
  State<SupplementMessagePage> createState() => _SupplementMessagePageState();
}

class _SupplementMessagePageState extends State<SupplementMessagePage> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _contactName1Controller = TextEditingController();
  final TextEditingController _contactPhone1Controller =
      TextEditingController();
  final TextEditingController _contactName2Controller = TextEditingController();
  final TextEditingController _contactPhone2Controller =
      TextEditingController();

  int _relation1 = 4;
  int _relation2 = 4;
  int _repaymentIndex = 0;
  bool _agreed = false;

  static const List<String> _repaymentDays = ['5号', '10号'];
  static const List<String> _billingDays = ['1号', '5号'];
  static const List<String> _relationLabels = ['父母', '配偶', '子女', '兄弟姐妹', '同事'];

  @override
  void dispose() {
    _companyController.dispose();
    _jobController.dispose();
    _addressController.dispose();
    _contactName1Controller.dispose();
    _contactPhone1Controller.dispose();
    _contactName2Controller.dispose();
    _contactPhone2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFlowViewModel(),
      child: Consumer<AuthFlowViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: 44.h),
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: Column(
                      children: [
                        _buildRepaymentSection(),
                        _buildInfoInput('工作单位', _companyController, '请填写全称'),
                        _buildInfoInput('工作职位', _jobController, '请输入工作职位'),
                        _buildInfoInput(
                            '所在城市', _addressController, '如城镇、省份、市区、道路等'),
                        _buildScoreUpload(vm),
                        _buildContactCard(
                          title: '联系人一',
                          nameController: _contactName1Controller,
                          phoneController: _contactPhone1Controller,
                          relationValue: _relation1,
                          onRelationChanged: (value) {
                            setState(() => _relation1 = value ?? _relation1);
                          },
                        ),
                        _buildContactCard(
                          title: '联系人二',
                          nameController: _contactName2Controller,
                          phoneController: _contactPhone2Controller,
                          relationValue: _relation2,
                          onRelationChanged: (value) {
                            setState(() => _relation2 = value ?? _relation2);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottom(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 52.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5.w,
            child: GestureDetector(
              onTap: () => NavigatorService.instance.pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  'assets/images/icon_back.webp',
                  width: 12.w,
                  height: 18.h,
                ),
              ),
            ),
          ),
          Text(
            '信息填写',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1A1A1A)),
          ),
        ],
      ),
    );
  }

  Widget _buildRepaymentSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '设定月付日(每月)',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(_repaymentDays.length, (index) {
              final selected = _repaymentIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _repaymentIndex = index),
                child: Container(
                  margin: EdgeInsets.only(right: 9.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFFF3530)
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                  child: Text(
                    _repaymentDays[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selected
                          ? const Color(0xFFFF3530)
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          Text(
            '月付提醒日：每月${_billingDays[_repaymentIndex]}',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoInput(
    String title,
    TextEditingController controller,
    String hint,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              title,
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(fontSize: 15.sp, color: const Color(0xFFB3B3B3)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreUpload(AuthFlowViewModel vm) {
    final scoreUrl = vm.scoreImageUrl;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 23.h, 12.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '上传芝麻分截图',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333)),
          ),
          SizedBox(height: 6.h),
          Text(
            '请打开支付宝-我的-芝麻信用-截图',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => _pickScoreImage(vm),
            child: Container(
              width: 87.w,
              height: 87.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                image: DecorationImage(
                  image: scoreUrl != null && scoreUrl.isNotEmpty
                      ? NetworkImage(scoreUrl)
                      : const AssetImage('assets/images/id_card_front.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/icon_upload_add.png',
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required int relationValue,
    required ValueChanged<int?> onRelationChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          _buildInfoInput(title, nameController, '请填入联系人姓名'),
          _buildInfoInput('手机号码', phoneController, '请填入手机号'),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 110.w,
                  child: Text(
                    '关系',
                    style: TextStyle(
                        fontSize: 15.sp, color: const Color(0xFF333333)),
                  ),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: relationValue,
                      isExpanded: true,
                      items: List.generate(_relationLabels.length, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text(
                            _relationLabels[index],
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xFF333333)),
                          ),
                        );
                      }),
                      onChanged: onRelationChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildBottom(AuthFlowViewModel vm) {
    return Container(
      height: 100.h,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Image.asset(
                    _agreed
                        ? 'assets/images/ic_select.png'
                        : 'assets/images/ic_un_select.png',
                    width: 15.w,
                    height: 15.w,
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.nav.push(
                        RoutePaths.other.webview,
                        arguments: {'url': '', 'title': '信息填写协议'},
                      );
                    },
                    child: Text(
                      '已阅读并同意《信息填写相关协议》',
                      style: TextStyle(
                          fontSize: 13.sp, color: const Color(0xFF888888)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: vm.isLoading ? null : () => _submit(vm),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              height: 49.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _agreed
                    ? const Color(0xFFFF3530)
                    : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(29.r),
              ),
              child: Text(
                vm.isLoading ? '提交中...' : '提交',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickScoreImage(AuthFlowViewModel vm) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final imageUrl = await vm.uploadScoreImage(file: File(file.path));
    if ((imageUrl ?? '').isEmpty) {
      LoadingManager.instance.showToast(vm.errorMessage ?? '上传失败');
    }
  }

  Future<void> _submit(AuthFlowViewModel vm) async {
    if ((vm.scoreImageUrl ?? '').isEmpty) {
      LoadingManager.instance.showToast('请上传芝麻分截图');
      return;
    }
    if (_companyController.text.trim().isEmpty) {
      LoadingManager.instance.showToast('请填写工作单位');
      return;
    }
    if (_jobController.text.trim().isEmpty) {
      LoadingManager.instance.showToast('请填写工作职位');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      LoadingManager.instance.showToast('请填写所在城市');
      return;
    }
    if (_contactName1Controller.text.trim().isEmpty ||
        _contactPhone1Controller.text.trim().isEmpty ||
        _contactName2Controller.text.trim().isEmpty ||
        _contactPhone2Controller.text.trim().isEmpty) {
      LoadingManager.instance.showToast('请填写联系人信息');
      return;
    }
    if (!_agreed) {
      LoadingManager.instance.showToast('请勾选协议');
      return;
    }
    final success = await vm.submitMonthApply(
      companyName: _companyController.text.trim(),
      position: _jobController.text.trim(),
      residenceAddress: _addressController.text.trim(),
      repaymentDate: _repaymentDays[_repaymentIndex].replaceAll('号', ''),
      billingDate: _billingDays[_repaymentIndex].replaceAll('号', ''),
      residentialLocationAddress: _addressController.text.trim(),
      emergencyName1: _contactName1Controller.text.trim(),
      emergencyNo1: _contactPhone1Controller.text.trim(),
      emergencyRelation1: _relation1,
      emergencyName2: _contactName2Controller.text.trim(),
      emergencyNo2: _contactPhone2Controller.text.trim(),
      emergencyRelation2: _relation2,
    );
    if (!success) {
      LoadingManager.instance.showToast(vm.errorMessage ?? '提交失败');
      return;
    }
    NavigatorService.instance.push(RoutePaths.other.examineIng);
    if (widget.isNeedClose) {
      NavigatorService.instance.pop();
    }
  }
}
