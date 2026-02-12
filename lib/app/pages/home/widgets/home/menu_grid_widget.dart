import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/home_models.dart';

/// 菜单网格组件
class MenuGridWidget extends StatelessWidget {
  final List<MenuCategoryEntity> menus;
  final Function(MenuCategoryEntity)? onTap;

  const MenuGridWidget({
    super.key,
    required this.menus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (menus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Android是5列
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          mainAxisExtent: 90.h,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap?.call(menu),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: menu.iconUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: CachedNetworkImage(
                            imageUrl: menu.iconUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.apps),
                          ),
                        )
                      : const Icon(Icons.apps),
                ),
                SizedBox(height: 10.h),
                Text(
                  menu.name ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
