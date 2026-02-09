import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 用户输入框组件 - 对应Android的UserNumberTextView和UserPasswordTextView
class UserInputField extends StatefulWidget {
  final String iconPath;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLength;
  final Function(String) onChanged;
  final bool showSendCode;
  final String? sendCodeText;
  final VoidCallback? onSendCode;

  const UserInputField({
    super.key,
    required this.iconPath,
    required this.hintText,
    required this.keyboardType,
    required this.maxLength,
    required this.onChanged,
    this.showSendCode = false,
    this.sendCodeText,
    this.onSendCode,
  });

  @override
  State<UserInputField> createState() => _UserInputFieldState();
}

class _UserInputFieldState extends State<UserInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          // 输入区域
          Expanded(
            child: Row(
              children: [
                // 左侧图标
                Image.asset(
                  widget.iconPath,
                  width: 20.w,
                  height: 20.w,
                ),

                SizedBox(width: 14.w),

                // 输入框
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    maxLength: widget.maxLength,
                    inputFormatters: widget.keyboardType == TextInputType.phone
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF333333), // color_333333
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF6A6F81), // color_6A6F81
                      ),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),

                // 发送验证码按钮
                if (widget.showSendCode)
                  GestureDetector(
                    onTap: widget.onSendCode,
                    child: Container(
                      margin: EdgeInsets.only(right: 9.w),
                      child: Text(
                        widget.sendCodeText ?? '获取验证码',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: widget.onSendCode != null
                              ? const Color(0xFFFF3530) // color_FF3530
                              : const Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 底部线条
          Container(
            height: 1.h,
            color: _isFocused
                ? const Color(0xFFFF3530) // color_FF3530 - 聚焦状态
                : const Color(0xFFE5E5E5), // color_E5E5E5 - 未聚焦状态
          ),
        ],
      ),
    );
  }
}