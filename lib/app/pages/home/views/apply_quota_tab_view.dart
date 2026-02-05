import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodels/apply_quota_viewmodel.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';

/// 月付申请Tab视图
class ApplyQuotaTabView extends StatefulWidget {
  const ApplyQuotaTabView({Key? key}) : super(key: key);

  @override
  State<ApplyQuotaTabView> createState() => _ApplyQuotaTabViewState();
}

class _ApplyQuotaTabViewState extends State<ApplyQuotaTabView>
    with AutomaticKeepAliveClientMixin {
  late ApplyQuotaViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // 延迟初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<ApplyQuotaViewModel>(context, listen: false);
      _viewModel.refresh();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('月付申请'),
        centerTitle: true,
      ),
      body: Consumer<ApplyQuotaViewModel>(
        builder: (context, viewModel, child) {
          // 加载中
          if (viewModel.isLoading && viewModel.userCreditDetail == null) {
            return const LoadingWidget(message: '加载中...');
          }

          // 加载失败
          if (viewModel.errorMessage != null &&
              viewModel.userCreditDetail == null) {
            return ErrorStateWidget(
              message: viewModel.errorMessage,
              onRetry: () => viewModel.refresh(),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 额度信息卡片
                _buildCreditCard(viewModel),

                SizedBox(height: 16.h),

                // 申请状态
                _buildStatusCard(viewModel),

                SizedBox(height: 24.h),

                // 申请按钮
                _buildApplyButton(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreditCard(ApplyQuotaViewModel viewModel) {
    final myCreditLimit = viewModel.myCreditLimit;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '我的额度',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '¥${myCreditLimit?.totalLimit?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCreditItem(
                '可用额度',
                '¥${myCreditLimit?.availableLimit?.toStringAsFixed(2) ?? '0.00'}',
              ),
              _buildCreditItem(
                '已使用',
                '¥${myCreditLimit?.usedLimit?.toStringAsFixed(2) ?? '0.00'}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(ApplyQuotaViewModel viewModel) {
    final status = viewModel.userCreditDetail?.status ?? 0;
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = '未申请';
        statusColor = Colors.grey;
        break;
      case 1:
        statusText = '审核中';
        statusColor = Colors.orange;
        break;
      case 2:
        statusText = '已通过';
        statusColor = Colors.green;
        break;
      case 3:
        statusText = '已拒绝';
        statusColor = Colors.red;
        break;
      default:
        statusText = '未知状态';
        statusColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: statusColor,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Text(
            '申请状态：',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(ApplyQuotaViewModel viewModel) {
    final status = viewModel.userCreditDetail?.status ?? 0;
    final isAuthenticated = viewModel.isAuthenticated;

    String buttonText;
    VoidCallback? onPressed;

    if (status == 0) {
      buttonText = '立即申请';
      onPressed = () {
        print('跳转到申请页面');
      };
    } else if (status == 1) {
      buttonText = '审核中';
      onPressed = null;
    } else if (status == 2) {
      buttonText = '已通过';
      onPressed = null;
    } else {
      buttonText = '重新申请';
      onPressed = () {
        print('跳转到申请页面');
      };
    }

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
