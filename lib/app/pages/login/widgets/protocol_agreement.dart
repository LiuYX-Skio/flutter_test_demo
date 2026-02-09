import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProtocolAgreement extends StatelessWidget {
  final bool isAgreed;
  final VoidCallback onToggle;
  final VoidCallback onUserProtocol;
  final VoidCallback onPrivacyProtocol;

  const ProtocolAgreement({
    super.key,
    required this.isAgreed,
    required this.onToggle,
    required this.onUserProtocol,
    required this.onPrivacyProtocol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        bottom: 60.h,
        top: 30.h,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 2.h,),
                GestureDetector(
                  onTap: onToggle,
                  child: Image.asset(
                    isAgreed
                        ? 'assets/images/ic_select.png'
                        : 'assets/images/ic_un_select.png',
                    width: 15.w,
                    height: 15.w,
                  ),
                )
              ],
            ),

            SizedBox(width: 11.w),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '我已阅读并同意',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: onUserProtocol,
                      child: Text(
                        '《用户协议》',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFFF3530),
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: '和',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: onPrivacyProtocol,
                      child: Text(
                        '《隐私协议》',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFFF3530),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
