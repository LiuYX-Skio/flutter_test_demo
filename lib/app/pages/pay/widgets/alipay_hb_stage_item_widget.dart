import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlipayHbStageItemWidget extends StatelessWidget {
  final bool selected;
  final int stageNum;
  final double totalMoney;
  final double stageRate;
  final bool showLine;
  final VoidCallback? onTap;

  const AlipayHbStageItemWidget({
    super.key,
    required this.selected,
    required this.stageNum,
    required this.totalMoney,
    required this.stageRate,
    this.showLine = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final each = stageNum == 0 ? 0 : totalMoney / stageNum;
    final fee = each * stageRate;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(width: 40.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¥${each.toStringAsFixed(2)}*$stageNum期',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '手续费 ¥${fee.toStringAsFixed(2)}/期',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF707070),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  selected
                      ? 'assets/images/icon_pay_select.webp'
                      : 'assets/images/ic_un_select.png',
                  width: 20.w,
                  height: 20.w,
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),
        if (showLine)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            height: 1.h,
            color: const Color(0xFFEDEDED),
          ),
      ],
    );
  }
}
