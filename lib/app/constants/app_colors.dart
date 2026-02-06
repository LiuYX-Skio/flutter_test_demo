import 'package:flutter/material.dart';

/// 应用颜色常量
/// 从Android项目的colors.xml一比一还原
class AppColors {
  AppColors._();

  // 基础颜色
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // 主题色
  static const Color colorFF3530 = Color(0xFFFF3530);
  static const Color colorFF4843 = Color(0xFFFF4843);

  // 文字颜色
  static const Color color333333 = Color(0xFF333333);
  static const Color color666666 = Color(0xFF666666);
  static const Color color888888 = Color(0xFF888888);
  static const Color color999999 = Color(0xFF999999);
  static const Color color909396 = Color(0xFF909396);

  // 背景颜色
  static const Color colorF7F9FC = Color(0xFFF7F9FC);
  static const Color colorF4F4F4 = Color(0xFFF4F4F4);
  static const Color colorCCCCCC = Color(0xFFCCCCCC);

  // 倒计时文字颜色
  static const Color countdownText = Color(0xFFFF9500);
}
