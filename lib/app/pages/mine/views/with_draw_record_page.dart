import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/mine_models.dart';
import '../viewmodels/wallet_viewmodel.dart';

class WithDrawRecordPage extends StatefulWidget {
  const WithDrawRecordPage({super.key});

  @override
  State<WithDrawRecordPage> createState() => _WithDrawRecordPageState();
}

class _WithDrawRecordPageState extends State<WithDrawRecordPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletViewModel>(context, listen: false)
          .fetchWithDrawRecord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: 44.h, color: Colors.white),
          _buildTopBar(),
          Expanded(
            child: Consumer<WalletViewModel>(
              builder: (context, viewModel, child) {
                final records = viewModel.records;
                if (records.isEmpty) {
                  return Center(
                    child: Text(
                      '暂无账单数据',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  );
                }
                return Container(
                  color: const Color(0xFFF3F4F5),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.h),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return _buildRecordItem(records[index]);
                    },
                  ),
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
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 12.w,
                height: 18.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '取现记录',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildRecordItem(WithDrawRecord record) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.createTime ?? '',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF999999),
                ),
              ),
              SizedBox(height: 14.h),
              _buildInfoRow(
                _getAccountLabel(record),
                _getAccountValue(record),
              ),
              SizedBox(height: 16.h),
              _buildInfoRow('取现金额', record.extractPrice ?? ''),
              SizedBox(height: 16.h),
              _buildInfoRow('取现单号', record.item ?? ''),
              SizedBox(height: 16.h),
              _buildInfoRow('取现状态', _getStatusText(record.status)),
            ],
          ),
        ),
        Container(height: 8.h, color: const Color(0xFFF3F4F5)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  String _getAccountLabel(WithDrawRecord record) {
    if (record.extractType == 'alipay') {
      return '支付宝账号';
    }
    if (record.extractType == 'bank') {
      return '银行名称';
    }
    if (record.extractType == 'weixin') {
      return '微信账号';
    }
    return '未知渠道';
  }

  String _getAccountValue(WithDrawRecord record) {
    if (record.extractType == 'alipay') {
      return record.alipayCode ?? '';
    }
    if (record.extractType == 'bank') {
      return record.bankName ?? '';
    }
    if (record.extractType == 'weixin') {
      return record.wechat ?? '';
    }
    return '未知';
  }

  String _getStatusText(int? status) {
    if (status == 0) {
      return '审核中';
    }
    if (status == 1) {
      return '已取现';
    }
    return '未通过';
  }
}
