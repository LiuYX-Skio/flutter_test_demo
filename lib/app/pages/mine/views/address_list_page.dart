import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../navigation/core/navigator_service.dart';
import '../../../../navigation/core/route_paths.dart';
import '../models/address_models.dart';
import '../viewmodels/address_viewmodel.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  bool _isUpdateAddress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _isUpdateAddress = args?['isUpdateAddress'] as bool? ?? false;
      Provider.of<AddressViewModel>(context, listen: false).fetchAddressList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(),
          Container(height: 8.h, color: Colors.white),
          Expanded(
            child: Consumer<AddressViewModel>(
              builder: (context, viewModel, child) {
                final list = viewModel.addresses;
                if (list.isEmpty) {
                  return _buildEmpty();
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 12.h),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _buildAddressItem(list[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 44.h,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 11.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '收货地址',
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onAddAddress,
            child: Container(
              height: 28.h,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icon_add_address.webp',
                    width: 8.w,
                    height: 8.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '新增地址',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFFF3530),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        SizedBox(height: 85.h),
        Image.asset(
          'assets/images/icon_no_address.webp',
          width: 215.w,
          height: 134.h,
          fit: BoxFit.fill,
        ),
        SizedBox(height: 18.h),
        Text(
          '暂无收货地址',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
        SizedBox(height: 30.h),
        GestureDetector(
          onTap: _onAddAddress,
          child: Container(
            width: 146.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3530),
              borderRadius: BorderRadius.circular(21.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '新增地址',
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressItem(UserAddressEntity address) {
    return GestureDetector(
      onTap: () => _onSelectAddress(address),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 15.h,
          bottom: 9.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.realName ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            address.phone ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13.h),
                      Row(
                        children: [
                          if (address.isDefault == true)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              margin: EdgeInsets.only(right: 7.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEEEE),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Text(
                                '默认',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFFF3530),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              address.fullAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _onEditAddress(address),
                  child: Image.asset(
                    'assets/images/icon_address_edit.webp',
                    width: 14.w,
                    height: 14.w,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 17.h),
              height: 0.5.h,
              color: const Color(0xFFEDEFF2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 9.h),
              child: Row(
                children: [
                  Image.asset(
                    address.isDefault == true
                        ? 'assets/images/icon_address_select.webp'
                        : 'assets/images/icon_address_unselect.webp',
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      '默认地址',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onDeleteAddress(address),
                    child: Image.asset(
                      'assets/images/icon_address_delete.webp',
                      width: 14.w,
                      height: 14.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectAddress(UserAddressEntity address) {
    if (_isUpdateAddress) {
      Navigator.of(context).pop(address);
      return;
    }
    _onEditAddress(address);
  }

  void _onAddAddress() {
    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }
    context.nav.push(RoutePaths.user.addAddress).then((_) {
      Provider.of<AddressViewModel>(context, listen: false)
          .fetchAddressList();
    });
  }

  void _onEditAddress(UserAddressEntity address) {
    if (!UserProvider.isLogin()) {
      context.nav.push(RoutePaths.auth.login);
      return;
    }
    context.nav.push(
      RoutePaths.user.addAddress,
      arguments: {'addressId': address.id},
    ).then((_) {
      Provider.of<AddressViewModel>(context, listen: false)
          .fetchAddressList();
    });
  }

  void _onDeleteAddress(UserAddressEntity address) {
    if (address.id == null) return;
    Provider.of<AddressViewModel>(context, listen: false)
        .deleteAddress(address.id!)
        .then((_) {
      LoadingManager.instance.showToast('删除成功');
    });
  }
}
