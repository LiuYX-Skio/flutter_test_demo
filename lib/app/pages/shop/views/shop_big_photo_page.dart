import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../navigation/core/navigator_service.dart';

class ShopBigPhotoPage extends StatelessWidget {
  final String? photo;

  const ShopBigPhotoPage({
    super.key,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final image = photo ?? '';
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => NavigatorService.instance.pop(),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.contain,
            placeholder: (_, __) => SizedBox(
              width: 30.w,
              height: 30.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 36.w,
            ),
          ),
        ),
      ),
    );
  }
}

