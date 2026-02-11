import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_models.dart';
import '../widgets/recycle_order_item_widget.dart';

class GoldRecycleOrderPage extends StatefulWidget {
  final int currentPage;

  const GoldRecycleOrderPage({
    super.key,
    this.currentPage = 0,
  });

  @override
  State<GoldRecycleOrderPage> createState() => _GoldRecycleOrderPageState();
}

class _GoldRecycleOrderPageState extends State<GoldRecycleOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _titles = const [
    '待回购',
    '检测中',
    '待确认',
    '已打款',
  ];

  late final OrderInfoListEntity _sampleData = OrderInfoListEntity(
    productId: '16',
    cartNum: 1,
    image:
        'https://xilehua.oss-cn-hangzhou.aliyuncs.com//crmebimage/public/product/2024/07/24/020d1d292bc44b61843517421d2ea776unxqlqm5ry.png',
    storeName: '多功能健腹板新款健腹轮自动回弹卷腹练腹肌平板支撑居家健身器材',
    price: '198.00',
    isReply: 0,
    sku: '默认',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _titles.length,
      vsync: this,
      initialIndex: widget.currentPage,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = List<OrderInfoListEntity>.generate(7, (_) => _sampleData);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildTopBar(),
          _buildSearchBar(),
          Container(height: 1.h, color: const Color(0xFFF5F5F5)),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _titles.map((_) {
                return ListView.separated(
                  padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return RecycleOrderItemWidget(data: items[index]);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                '商品回收',
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

  Widget _buildSearchBar() {
    return Container(
      height: 34.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/icon_search.webp',
            width: 14.w,
            height: 14.w,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                hintText: '请输入订单号搜索',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF999999),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 40.h,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFFD9B279),
        unselectedLabelColor: const Color(0xFF666666),
        indicatorColor: const Color(0xFFD9B279),
        indicatorWeight: 2.h,
        labelStyle: TextStyle(fontSize: 14.sp),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp),
        tabs: _titles.map((e) => Tab(text: e)).toList(),
      ),
    );
  }
}
