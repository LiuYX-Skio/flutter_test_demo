import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 功能入口项
class FeatureItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FeatureItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

/// 功能入口网格组件
class FeatureGridWidget extends StatelessWidget {
  final List<FeatureItem> features;

  const FeatureGridWidget({
    Key? key,
    required this.features,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 1.0,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: feature.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature.icon,
                  size: 32.w,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 8.h),
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
