import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import 'order_message_widget.dart';

class RecycleOrderItemWidget extends StatelessWidget {
  final OrderInfoListEntity data;
  final VoidCallback? onTap;

  const RecycleOrderItemWidget({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/icon_dp.png',
                  width: 18.w,
                  height: 18.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '商品名称',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 17.h),
            OrderMessageWidget(data: data),
          ],
        ),
      ),
    );
  }
}
