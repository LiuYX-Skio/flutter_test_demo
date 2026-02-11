import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/month_pay_viewmodel.dart';
import '../models/mine_models.dart';

class MineBillPage extends StatefulWidget {
  const MineBillPage({super.key});

  @override
  State<MineBillPage> createState() => _MineBillPageState();
}

class _MineBillPageState extends State<MineBillPage> {
  late MonthPayViewModel _viewModel;
  String _year = '';
  String _month = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year.toString();
    _month = now.month < 10 ? '0${now.month}' : now.month.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<MonthPayViewModel>(context, listen: false);
      _viewModel.fetchMonthPayList(year: _year, month: _month, showLoading: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<MonthPayViewModel>(
        builder: (context, viewModel, child) {
          final list = viewModel.monthPayData?.list ?? [];
          final hasData = list.isNotEmpty;

          return Column(
            children: [
              SizedBox(height: 44.h),
              _buildTopBar(),
              if (!hasData)
                Expanded(
                  child: Center(
                    child: Text(
                      '暂无账单数据',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      _buildDatePicker(),
                      Container(height: 1.h, color: const Color(0xFFEBEBEB)),
                      _buildSummary(viewModel.monthPayData),
                      Container(height: 8.h, color: const Color(0xFFF3F4F5)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return _buildBillItem(item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          SizedBox(width: 5.w),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                'assets/images/icon_back.webp',
                width: 12.w,
                height: 18.h,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '账单明细',
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _showDatePicker,
      child: Container(
        margin: EdgeInsets.only(top: 14.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_year-$_month',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(width: 10.w),
            Image.asset(
              'assets/images/icon_bill_detail.webp',
              width: 7.w,
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(UserMonthPayEntity? data) {
    return Column(
      children: [
        Container(
          height: 43.h,
          width: double.infinity,
          color: const Color(0xFFF3F4F5),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 12.w),
          child: const Text('总明细(含退款、还款)'),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    '已用(元)',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    _formatMoney(data?.creditUseAmount),
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: const Color(0xFF06B066),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    '剩余(元)',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    _formatMoney(data?.creditAmountResult),
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: const Color(0xFFFF4046),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillItem(MonthPayListEntity? item) {
    if (item == null) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.createdAt ?? '',
                style: TextStyle(fontSize: 15.sp, color: const Color(0xFF999999)),
              ),
              SizedBox(height: 14.h),
              _buildRow('账单名称', item.billName ?? ''),
              SizedBox(height: 16.h),
              _buildRow('账单金额', '-${item.billPrice ?? ''}', valueColor: const Color(0xFF06B066)),
              if ((item.repaymentAmount ?? 0) > 0) ...[
                SizedBox(height: 16.h),
                _buildRow('已还金额', (item.repaymentAmount ?? 0).toString()),
              ],
              SizedBox(height: 16.h),
              _buildRow('支付日期', item.paymentDate ?? ''),
              SizedBox(height: 6.h),
            ],
          ),
        ),
        Container(height: 8.h, color: const Color(0xFFF3F4F5)),
      ],
    );
  }

  Widget _buildRow(String label, String value, {Color valueColor = const Color(0xFF333333)}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, color: valueColor),
        ),
      ],
    );
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(int.parse(_year), int.parse(_month), 1),
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2099, 12, 31),
    );
    if (selected != null) {
      setState(() {
        _year = selected.year.toString();
        final m = selected.month;
        _month = m < 10 ? '0$m' : m.toString();
      });
      _viewModel.fetchMonthPayList(year: _year, month: _month, showLoading: true);
    }
  }

  String _formatMoney(String? value) {
    if (value == null || value.isEmpty) return '0';
    return value;
  }
}
