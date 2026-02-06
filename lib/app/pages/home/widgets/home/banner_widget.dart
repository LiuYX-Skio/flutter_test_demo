import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/home_models.dart';

/// 轮播图组件
class BannerWidget extends StatefulWidget {
  final List<BannerEntity> banners;
  final Function(BannerEntity)? onTap;

  const BannerWidget({
    Key? key,
    required this.banners,
    this.onTap,
  }) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 140.h, // Android中是140dp
        viewportFraction: 1.0, // 占满宽度
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5), // Android中是5000ms
        enlargeCenterPage: false,
      ),
      items: widget.banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => widget.onTap?.call(banner),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r), // Android中是6dp
                child: CachedNetworkImage(
                  imageUrl: banner.imageUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFCCCCCC),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFCCCCCC),
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
