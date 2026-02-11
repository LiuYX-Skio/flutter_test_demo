import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showGoldRecycleDescDialog(BuildContext context, int type) {
  final title = _titleByType(type);
  final content = _contentByType(type);
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 45.w),
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 270.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9B279),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String _titleByType(int type) {
  if (type == 1) {
    return '商品介绍';
  }
  if (type == 2) {
    return '费用信息';
  }
  return '回购规则';
}

String _contentByType(int type) {
  if (type == 1) {
    return '用户可在本商城进行订单内旧商品回收申请\n\n提交回收后须等待平台回收部门移交寄卖行回收处理，大概半个工作日，处理完毕后会以短信通知用户\n\n用户申请需上传旧商品的实物图片、购买单据等物品信息';
  }
  if (type == 2) {
    return '商品回收涉及的渠道费、服务费、撮合费、居间费等由用户自身承担，因此回收价格不等于购买价格\n\n回收价格：以实际填写信息显示的回收价格为准\n\n指定物流合作单位为：邮政速递、顺丰速递\n\n';
  }
  return '为确保用户申请通过，平台回收部门须对回收订单审核，检验，所以用户须等待一定的时间，大概一个工作日\n处理完毕后，平台会以短信的方式通知用户\n\n用户确认后，结算完成，如未确认会将称重检测后的商品邮寄/退单返回用户';
}
