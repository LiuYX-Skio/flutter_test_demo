import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/shop_detail_models.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 商品详情评论Widget
/// 对应 Android 的 ShopDetailCommentView
class ShopDetailCommentWidget extends StatelessWidget {
  /// 评论数据
  final ShopCommentOutEntity? commentData;

  /// 查看全部评论回调
  final VoidCallback? onViewAllTap;

  const ShopDetailCommentWidget({
    super.key,
    this.commentData,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (commentData == null || commentData!.list == null || commentData!.list!.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstComment = commentData!.list!.first;
    final ShopCommentEntity? secondComment =
        commentData!.list!.length > 1 ? commentData!.list![1] : null;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '商品评价',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  '（${commentData!.total ?? 0}）',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF666666),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '查看全部',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Image.asset(
                        'assets/images/icon_detail_arrow.png',
                        width: 8.w,
                        height: 12.h,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 评论内容
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
            child: _buildCommentItem(firstComment),
          ),
          if (secondComment != null)
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
              child: _buildCommentItem(secondComment),
            ),
        ],
      ),
    );
  }

  /// 构建评论项
  Widget _buildCommentItem(ShopCommentEntity comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 用户信息
        Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: comment.avatar ?? '',
                width: 33.w,
                height: 33.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 33.w,
                  height: 33.w,
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  width: 33.w,
                  height: 33.w,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${comment.nickname ?? ''}  ${comment.createTime ?? ''}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _buildStarRating(comment.score ?? 5),
                ],
              ),
            ),
          ],
        ),
        if ((comment.comment ?? '').isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              comment.comment ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
      ],
    );
  }

  /// 构建星级评分
  Widget _buildStarRating(int score) {
    final int normalizedScore = score > 5 ? 5 : score;
    return Row(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 4.5.w),
          child: Image.asset(
            index < normalizedScore
                ? 'assets/images/shop_star.png'
                : 'assets/images/shop_un_star.png',
            width: 10.w,
            height: 10.h,
          ),
        );
      }),
    );
  }

}
