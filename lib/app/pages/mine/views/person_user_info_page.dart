import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../app/utils/string_utils.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../../home/api/user_api.dart';

class PersonUserInfoPage extends StatefulWidget {
  const PersonUserInfoPage({super.key});

  @override
  State<PersonUserInfoPage> createState() => _PersonUserInfoPageState();
}

class _PersonUserInfoPageState extends State<PersonUserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _initUserInfo();
  }

  Future<void> _initUserInfo() async {
    await UserProvider.updateUserInfo();
    final nickname = StringUtils.getNotNullParam(UserProvider.getUserNickName());
    _nameController.text = nickname.isEmpty ? '登录' : nickname;
    _avatarUrl = UserProvider.getUserAvatar();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(),
          SizedBox(height: 40.h),
          _buildAvatar(),
          SizedBox(height: 12.h),
          _buildNameRow(),
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
                '个人信息',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onConfirm,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Text(
                '确认',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFDB5917),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final imageProvider = _avatarUrl != null && _avatarUrl!.isNotEmpty
        ? CachedNetworkImageProvider(_avatarUrl!)
        : const AssetImage('assets/images/icon_default.png') as ImageProvider;
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _onPickAvatar,
        child: Container(
          width: 50.w,
          height: 50.w,
          margin: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildNameRow() {
    return Container(
      height: 45.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(
            '昵称',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF333333),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _nameController,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
              ),
              decoration: InputDecoration(
                hintText: '请输入昵称',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFCCCCCC),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPickAvatar() async {
    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final imageFile = File(file.path);
    await UserApi.uploadImage(
      filePath: imageFile.path,
      showLoading: true,
      onSuccess: (data) async {
        final url = data?.url ?? '';
        if (url.isNotEmpty) {
          await UserProvider.setUserAvatar(url);
          setState(() {
            _avatarUrl = url;
          });
          await UserApi.updateUserInfo(avatar: url);
        }
      },
      onError: (exception) {
        LoadingManager.instance.showToast('图片选择失败');
      },
    );
  }

  Future<void> _onConfirm() async {
    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }
    final nickname = _nameController.text.trim();
    if (nickname.isNotEmpty) {
      await UserApi.updateUserInfo(
        nickname: nickname,
        onSuccess: (_) async {
          await UserProvider.setUserNickName(nickname);
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
