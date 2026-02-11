import 'package:flutter/material.dart';
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

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '商品评价',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onViewAllTap,
                child: Row(
                  children: [
                    Text(
                      '查看全部(${commentData!.total ?? 0})',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 评论内容
          _buildCommentItem(firstComment),
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
            // 用户头像
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: comment.avatar ?? '',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 36,
                  height: 36,
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  width: 36,
                  height: 36,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // 用户名和评分
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.nickname ?? '匿名用户',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(comment.score ?? 5),
                ],
              ),
            ),

            // 评论时间
            Text(
              comment.createTime ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 评论内容
        Text(
          comment.comment ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 构建星级评分
  Widget _buildStarRating(int score) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < score ? Icons.star : Icons.star_border,
          size: 14,
          color: const Color(0xFFFFB800),
        );
      }),
    );
  }

}
