import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/utils/string_utils.dart';
import '../models/address_models.dart';
import '../models/address_tree_models.dart';
import '../viewmodels/address_viewmodel.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key, this.addressId});

  final String? addressId;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  String? _province;
  String? _city;
  String? _cityId;
  String? _district;

  bool _isDefault = true;
  bool _hasAddressDetail = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AddressViewModel>(context, listen: false);
      viewModel.fetchCityTree(onSuccess: (_) {});
      if (widget.addressId != null && widget.addressId!.isNotEmpty) {
        viewModel.fetchAddressDetail(
          id: widget.addressId!,
          onSuccess: (data) {
            _hasAddressDetail = true;
            _fillAddress(data);
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _fillAddress(UserAddressEntity? data) {
    if (data == null) return;
    _nameController.text = StringUtils.getNotNullParam(data.realName);
    _phoneController.text = StringUtils.getNotNullParam(data.phone);
    _detailController.text = StringUtils.getNotNullParam(data.detail);
    _province = data.province;
    _city = data.city;
    _district = data.district;
    _cityId = data.cityId;
    _isDefault = data.isDefault ?? true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.addressId != null && widget.addressId!.isNotEmpty;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardInset + 20.h),
          child: Column(
            children: [
              SizedBox(height: 44.h),
              _buildTopBar(isEdit),
              SizedBox(height: 10.h),
              _buildInputRow(
                title: '收货人',
                hint: '请填写收货人真实姓名',
                controller: _nameController,
              ),
              _buildDivider(),
              _buildInputRow(
                title: '手机号码',
                hint: '请填写收货人手机号',
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: 11,
              ),
              _buildDivider(),
              _buildDistrictRow(),
              _buildDivider(),
              _buildInputRow(
                title: '详细地址',
                hint: '如道路、门牌号、小区、楼栋号、单元室等',
                controller: _detailController,
              ),
              _buildDivider(),
              _buildDefaultRow(),
              SizedBox(height: 40.h),
              _buildSaveButton(),
              SizedBox(height: 75.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isEdit) {
    return SizedBox(
      height: 44.h,
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
            child: Center(
              child: Text(
                isEdit ? '修改地址' : '新增地址',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String title,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          SizedBox(
            width: 95.w,
            child: Text(
              title,
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                counterText: '',
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFB3B3B3),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictRow() {
    return GestureDetector(
      onTap: _showCityPicker,
      child: Container(
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SizedBox(
              width: 95.w,
              child: Text(
                '所在地区',
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333)),
              ),
            ),
            Expanded(
              child: Text(
                _districtText(),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: _districtText().isEmpty
                      ? const Color(0xFFB3B3B3)
                      : const Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _districtText() {
    if (StringUtils.isEmpty(_province) &&
        StringUtils.isEmpty(_city) &&
        StringUtils.isEmpty(_district)) {
      return '省市区县、乡镇等';
    }
    if (StringUtils.isEmpty(_district)) {
      return '${_province ?? ''}-${_city ?? ''}';
    }
    return '${_province ?? ''}-${_city ?? ''}-${_district ?? ''}';
  }

  Widget _buildDefaultRow() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isDefault = !_isDefault),
      child: Container(
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '设置默认地址',
                style:
                    TextStyle(fontSize: 16.sp, color: const Color(0xFF333333)),
              ),
            ),
            Image.asset(
              _isDefault
                  ? 'assets/images/icon_open.png'
                  : 'assets/images/icon_close.png',
              width: 40.w,
              height: 20.h,
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SizedBox(
        width: double.infinity,
        height: 44.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFF3530),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          onPressed: _onSave,
          child: Text(
            '保存',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5.h,
      color: const Color(0xFFE6E6E6),
    );
  }

  void _onSave() {
    if (_nameController.text.isEmpty) {
      LoadingManager.instance.showToast('请填写收货人真实姓名');
      return;
    }
    if (_phoneController.text.isEmpty) {
      LoadingManager.instance.showToast('请填写收货人手机号');
      return;
    }
    if (_districtText().isEmpty ||
        (_province == null && _city == null && _district == null)) {
      LoadingManager.instance.showToast('请填写收货人所在地区');
      return;
    }
    if (_detailController.text.isEmpty) {
      LoadingManager.instance.showToast('请填写收货人地址');
      return;
    }
    if (widget.addressId != null &&
        widget.addressId!.isNotEmpty &&
        !_hasAddressDetail) {
      LoadingManager.instance.showToast('正在获取地址数据，请稍等');
      return;
    }

    final data = UserAddressEntity(
      id: widget.addressId,
      realName: _nameController.text,
      phone: _phoneController.text,
      province: _province,
      city: _city,
      cityId: _cityId,
      district: _district,
      detail: _detailController.text,
      isDefault: _isDefault,
    );

    final viewModel = Provider.of<AddressViewModel>(context, listen: false);
    viewModel.saveAddress(
      address: data,
      onSuccess: (_) {
        LoadingManager.instance.showToast('保存成功');
        Navigator.of(context).pop(true);
      },
    );
  }

  void _showCityPicker() {
    final viewModel = Provider.of<AddressViewModel>(context, listen: false);
    if (viewModel.cityTree.isEmpty) {
      viewModel.fetchCityTree(onSuccess: (_) {
        _openPickerSheet(viewModel.cityTree);
      });
      return;
    }
    _openPickerSheet(viewModel.cityTree);
  }

  void _openPickerSheet(List<AddressProvince> provinces) {
    if (provinces.isEmpty) {
      LoadingManager.instance.showToast('地址数据为空');
      return;
    }

    int provinceIndex = 0;
    int cityIndex = 0;
    int countyIndex = 0;

    if (_province != null) {
      final index = provinces.indexWhere((e) => e.areaName == _province);
      if (index >= 0) provinceIndex = index;
    }

    final cities = provinces[provinceIndex].cities ?? [];
    if (_city != null && cities.isNotEmpty) {
      final index = cities.indexWhere((e) => e.areaName == _city);
      if (index >= 0) cityIndex = index;
    }

    final counties = cities.isNotEmpty
        ? (cities[cityIndex].counties ?? [])
        : <AddressCounty>[];
    if (_district != null && counties.isNotEmpty) {
      final index = counties.indexWhere((e) => e.areaName == _district);
      if (index >= 0) countyIndex = index;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        int tempProvinceIndex = provinceIndex;
        int tempCityIndex = cityIndex;
        int tempCountyIndex = countyIndex;
        final provinceController =
            FixedExtentScrollController(initialItem: provinceIndex);
        final cityController = FixedExtentScrollController(initialItem: cityIndex);
        final countyController =
            FixedExtentScrollController(initialItem: countyIndex);
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final currentCities =
                provinces[tempProvinceIndex].cities ?? <AddressCity>[];
            if (currentCities.isNotEmpty &&
                tempCityIndex > currentCities.length - 1) {
              tempCityIndex = 0;
            }
            final safeCities =
                currentCities.isNotEmpty ? currentCities : [AddressCity()];
            final currentCounties = currentCities.isNotEmpty
                ? (currentCities[tempCityIndex].counties ?? <AddressCounty>[])
                : <AddressCounty>[];
            if (currentCounties.isNotEmpty &&
                tempCountyIndex > currentCounties.length - 1) {
              tempCountyIndex = 0;
            }
            final safeCounties = currentCounties.isNotEmpty
                ? currentCounties
                : [AddressCounty()];
            return SizedBox(
              height: 360.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 44.h,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            final p = provinces[tempProvinceIndex];
                            final cList = p.cities ?? [];
                            AddressCity? c;
                            if (cList.isNotEmpty) {
                              c = cList[
                                  tempCityIndex.clamp(0, cList.length - 1)];
                            }
                            final countyList = c?.counties ?? [];
                            AddressCounty? county;
                            if (countyList.isNotEmpty) {
                              county = countyList[tempCountyIndex.clamp(
                                  0, countyList.length - 1)];
                            }
                            if (county == null) {
                              _province = p.areaName;
                              _city = p.areaName;
                              _district = c?.areaName;
                              _cityId = c?.areaId;
                            } else {
                              _province = p.areaName;
                              _city = c?.areaName;
                              _district = county.areaName;
                              _cityId = county.areaId;
                            }
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '确定',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFFF3530),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: provinceController,
                            itemExtent: 36.h,
                            onSelectedItemChanged: (index) {
                              setStateModal(() {
                                tempProvinceIndex = index;
                                tempCityIndex = 0;
                                tempCountyIndex = 0;
                                cityController.jumpToItem(0);
                                countyController.jumpToItem(0);
                              });
                            },
                            children: provinces
                                .map((e) => Center(
                                      child: Text(
                                        e.areaName ?? '',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: cityController,
                            itemExtent: 36.h,
                            onSelectedItemChanged: (index) {
                              setStateModal(() {
                                tempCityIndex = index;
                                tempCountyIndex = 0;
                                countyController.jumpToItem(0);
                              });
                            },
                            children: safeCities
                                .map((e) => Center(
                                      child: Text(
                                        e.areaName ?? '',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: countyController,
                            itemExtent: 36.h,
                            onSelectedItemChanged: (index) {
                              tempCountyIndex = index;
                            },
                            children: safeCounties
                                .map((e) => Center(
                                      child: Text(
                                        e.areaName ?? '',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
