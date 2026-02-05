import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'loading_widget.dart';

/// 通用下拉刷新列表组件
class RefreshListWidget extends StatelessWidget {
  final RefreshController controller;
  final VoidCallback onRefresh;
  final VoidCallback? onLoading;
  final Widget child;
  final bool enablePullUp;

  const RefreshListWidget({
    Key? key,
    required this.controller,
    required this.onRefresh,
    this.onLoading,
    required this.child,
    this.enablePullUp = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: true,
      enablePullUp: enablePullUp,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: WaterDropHeader(
        complete: Text(
          '刷新完成',
          style: TextStyle(fontSize: 14.sp),
        ),
        failed: Text(
          '刷新失败',
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(
              '上拉加载更多',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            );
          } else if (mode == LoadStatus.loading) {
            body = const SmallLoadingWidget();
          } else if (mode == LoadStatus.failed) {
            body = Text(
              '加载失败，点击重试',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            );
          } else if (mode == LoadStatus.canLoading) {
            body = Text(
              '松开加载更多',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            );
          } else {
            body = Text(
              '没有更多数据了',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            );
          }
          return Container(
            height: 55.h,
            child: Center(child: body),
          );
        },
      ),
      child: child,
    );
  }
}
