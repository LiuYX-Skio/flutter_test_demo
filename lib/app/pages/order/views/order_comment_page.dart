import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../viewmodels/order_detail_viewmodel.dart';

class OrderCommentPage extends StatefulWidget {
  final String? productId;
  final String? orderNo;
  final String? storeName;
  final String? imageUrl;

  const OrderCommentPage({
    super.key,
    this.productId,
    this.orderNo,
    this.storeName,
    this.imageUrl,
  });

  @override
  State<OrderCommentPage> createState() => _OrderCommentPageState();
}

class _OrderCommentPageState extends State<OrderCommentPage> {
  final TextEditingController _contentController = TextEditingController();
  int _score = 1;
  File? _imageFile;
  String? _imageUrl;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          _buildImagePicker(),
          _buildContentInput(),
          _buildProductInfo(),
          _buildRating(),
          _buildShareAndSubmit(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/icon_back.webp',
              width: 11.w,
              height: 18.h,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '商品评价',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: _imageFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon_t_camera.jpg',
                      width: 55.w,
                      height: 50.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '添加图视频',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.file(
                    _imageFile!,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/icon_t_voice.png',
            width: 16.w,
            height: 20.h,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: '展开说说对商品的想法吧...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9A9A9A),
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                ? Container(
                    width: 40.w,
                    height: 40.w,
                    color: const Color(0xFFCCCCCC),
                  )
                : CachedNetworkImage(
                    imageUrl: widget.imageUrl!,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 40.w,
                      height: 40.w,
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              widget.storeName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6F6F6F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        children: [
          Text(
            '综合评价',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10.w),
          Row(
            children: List.generate(5, (index) {
              final isSelected = index < _score;
              return GestureDetector(
                onTap: () => setState(() => _score = index + 1),
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Image.asset(
                    isSelected
                        ? 'assets/images/shop_star.png'
                        : 'assets/images/shop_un_star.png',
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShareAndSubmit() {
    return Container(
      margin: EdgeInsets.fromLTRB(40.w, 30.h, 40.w, 30.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_t_lock.png',
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '公开并分享',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Image.asset(
                      'assets/images/icon_t_bottom_arrow.png',
                      width: 16.w,
                      height: 16.w,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '分享到宝鱼商城',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6F6F6F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Image.asset(
                      'assets/images/icon_t_question.png',
                      width: 20.w,
                      height: 20.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: 120.w,
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3530),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Text(
                '发布',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _imageFile = File(file.path);
    });
    await Provider.of<OrderDetailViewModel>(context, listen: false).uploadImage(
      file: _imageFile!,
      onResult: (url) {
        _imageUrl = url;
      },
    );
  }

  void _submit() {
    if ((widget.productId ?? '').isEmpty || (widget.orderNo ?? '').isEmpty) {
      LoadingManager.instance.showToast('订单信息缺失');
      return;
    }
    Provider.of<OrderDetailViewModel>(context, listen: false).commentOrder(
      comment: _contentController.text.trim(),
      pics: _imageUrl,
      productId: widget.productId ?? '',
      orderNo: widget.orderNo ?? '',
      serviceScore: _score,
      onResult: (success) {
        if (success) {
          LoadingManager.instance.showToast('发布成功');
          Navigator.of(context).pop();
        }
      },
    );
  }
}
