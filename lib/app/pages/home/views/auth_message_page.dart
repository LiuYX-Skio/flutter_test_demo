import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../viewmodels/auth_flow_viewmodel.dart';

class AuthMessagePage extends StatefulWidget {
  final bool hasApply;
  final bool isNeedClose;

  const AuthMessagePage({
    super.key,
    this.hasApply = false,
    this.isNeedClose = false,
  });

  @override
  State<AuthMessagePage> createState() => _AuthMessagePageState();
}

class _AuthMessagePageState extends State<AuthMessagePage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNoController = TextEditingController();
  late final AuthFlowViewModel _flowViewModel;

  bool _agreed = false;
  bool _showManualInput = false;
  bool _showSwitchButton = false;
  String _ocrName = '';
  String _ocrCardNo = '';

  @override
  void initState() {
    super.initState();
    _flowViewModel = AuthFlowViewModel();
  }

  @override
  void dispose() {
    _flowViewModel.dispose();
    _nameController.dispose();
    _cardNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _flowViewModel,
      child: Consumer<AuthFlowViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  top: 44.h,
                  left: 0,
                  right: 0,
                  child: _buildTopBar(),
                ),
                Positioned(
                  top: 88.h,
                  left: 0,
                  right: 0,
                  bottom: 120.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10.h,
                          color: const Color(0xFFF3F4F5),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 80.h, 60.w, 0),
                          child: Text(
                            '实名认证仅用于月付开通，商城购物，您的信息将严格加密保护',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        Container(
                          height: 90.h,
                          margin: EdgeInsets.fromLTRB(25.w, 30.h, 25.w, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildCardImage(
                                  imageUrl: vm.frontImageUrl,
                                  placeholder: 'assets/images/id_card_front.png',
                                  onTap: () => _pickIdCard(vm, isFront: true),
                                ),
                              ),
                              SizedBox(width: 34.w),
                              Expanded(
                                child: _buildCardImage(
                                  imageUrl: vm.backImageUrl,
                                  placeholder: 'assets/images/id_card_back.png',
                                  onTap: () => _pickIdCard(vm, isFront: false),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_showManualInput)
                          Container(
                            margin: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 0),
                            child: Column(
                              children: [
                                _buildInput(
                                  controller: _nameController,
                                  hint: '请输入您的真实姓名',
                                ),
                                _buildInput(
                                  controller: _cardNoController,
                                  hint: '请输入您的身份证号码',
                                ),
                              ],
                            ),
                          ),
                        if (_showSwitchButton)
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showManualInput = !_showManualInput;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 12.h, right: 12.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3530),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Text(
                                  _showManualInput ? '切换为智能输入' : '切换为手动输入',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_ocrName.isNotEmpty || _ocrCardNo.isNotEmpty)
                          Container(
                            margin: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '真实姓名：$_ocrName',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 11.h),
                                Text(
                                  '身份证号：$_ocrCardNo',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 80.h, 60.w, 0),
                          child: Text(
                            'ps:请保持实名信息与手机号码一致。\n身份信息上传后请核对信息是否正确无误',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.h),
                          height: 10.h,
                          color: const Color(0xFFF3F4F5),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottom(vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 5.w,
            child: GestureDetector(
              onTap: () => NavigatorService.instance.pop(),
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  'assets/images/icon_back.webp',
                  width: 12.w,
                  height: 18.h,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            '实名认证',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage({
    required String? imageUrl,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final hasImage = (imageUrl ?? '').isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              image: DecorationImage(
                image: hasImage
                    ? CachedNetworkImageProvider(imageUrl!)
                    : AssetImage(placeholder) as ImageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          if (!hasImage)
            Center(
              child: Image.asset(
                'assets/images/id_card_camera.png',
                width: 35.w,
                height: 35.w,
                fit: BoxFit.fill,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 51.h,
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF333333),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFFCCCCCC),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom(AuthFlowViewModel vm) {
    return Container(
      height: 120.h,
      color: Colors.white,
      child: Column(
        children: [
          Container(height: 1.h, color: const Color(0xFFE6E6E6)),
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
                      NavigatorService.instance.push(
                        RoutePaths.other.webview,
                        arguments: {
                          'url': AppConstants.userProtocolUrl,
                          'title': '实名认证相关协议',
                        },
                      );
                    },
                    child: Text(
                      '已阅读并同意《实名认证相关协议》',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF888888),
                      ),
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
                borderRadius: BorderRadius.circular(24.5.r),
              ),
              child: Text(
                vm.isLoading ? '处理中...' : '刷脸',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIdCard(
    AuthFlowViewModel vm, {
    required bool isFront,
  }) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final upload = await vm.uploadIdCardImage(
      file: File(file.path),
      isFront: isFront,
    );
    if (upload == null) {
      setState(() {
        _showSwitchButton = true;
      });
      LoadingManager.instance.showToast(vm.errorMessage ?? '图片上传失败');
      return;
    }

    final imageUrl = upload.url ?? '';
    if (isFront) {
      vm.updateFrontImage(
        imageUrl: upload.url,
        realName: upload.name,
        idCard: upload.idCard,
      );
      if ((upload.name ?? '').trim().isNotEmpty) {
        _ocrName = upload.name!.trim();
      }
      if ((upload.idCard ?? '').trim().isNotEmpty) {
        _ocrCardNo = upload.idCard!.trim();
      }
      if (imageUrl.isEmpty ||
          (upload.name ?? '').trim().isEmpty ||
          (upload.idCard ?? '').trim().isEmpty) {
        _showSwitchButton = true;
      }
    } else {
      vm.updateBackImage(imageUrl: upload.url);
      if (imageUrl.isEmpty) {
        _showSwitchButton = true;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit(AuthFlowViewModel vm) async {
    if (!_agreed) {
      LoadingManager.instance.showToast('请勾选协议');
      return;
    }

    final hasAuthed = await vm.hasAuthentication();
    if (hasAuthed) {
      NavigatorService.instance.push(
        RoutePaths.other.supplementMessage,
        arguments: {
          'hasApply': widget.hasApply,
          'isNeedClose': widget.isNeedClose,
        },
      );
      NavigatorService.instance.pop();
      return;
    }

    final hasFront = (vm.frontImageUrl ?? '').isNotEmpty;
    final hasBack = (vm.backImageUrl ?? '').isNotEmpty;
    var needMetaVerify = false;

    if (!hasFront || !hasBack) {
      final name = _nameController.text.trim();
      final cardNo = _cardNoController.text.trim();
      if (name.isEmpty || cardNo.isEmpty) {
        LoadingManager.instance.showToast('请进行实名认证');
        return;
      }
      vm.updateManualIdentity(name: name, cardNo: cardNo);
      needMetaVerify = true;
    } else if (_ocrName.isNotEmpty && _ocrCardNo.isNotEmpty) {
      vm.updateManualIdentity(name: _ocrName, cardNo: _ocrCardNo);
    } else {
      final name = _nameController.text.trim();
      final cardNo = _cardNoController.text.trim();
      if (name.isNotEmpty && cardNo.isNotEmpty) {
        vm.updateManualIdentity(name: name, cardNo: cardNo);
      }
    }

    final success = await vm.submitAuth(needMetaVerify: needMetaVerify);
    if (!success) {
      LoadingManager.instance.showToast(vm.errorMessage ?? '认证失败');
      return;
    }

    NavigatorService.instance.push(
      RoutePaths.other.supplementMessage,
      arguments: {
        'hasApply': widget.hasApply,
        'isNeedClose': widget.isNeedClose,
      },
    );
    NavigatorService.instance.pop();
  }
}
