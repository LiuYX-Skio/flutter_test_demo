import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/user_models.dart';

/// 用户信息头部组件
class UserHeaderWidget extends StatelessWidget {
  final UserInfoEntity? userInfo;
  final VoidCallback? onTap;

  const UserHeaderWidget({
    super.key,
    this.userInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 头像
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: userInfo?.avatar ?? '',
                  width: 64.w,
                  height: 64.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 32.w,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 32.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo?.nickname ?? '未登录',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userInfo?.phone ?? '点击登录',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    if (userInfo?.nowMoney != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        '余额：¥${userInfo!.nowMoney!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 箭头
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
