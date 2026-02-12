import 'package:flutter/material.dart';
import 'package:flutter_test_demo/app/pages/home/home_page.dart';
import 'package:provider/provider.dart';
import 'viewmodels/main_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/sort_viewmodel.dart';
import 'viewmodels/apply_quota_viewmodel.dart';
import 'viewmodels/mine_viewmodel.dart';

/// Home模块的Provider包装器
/// 提供所有ViewModel的依赖注入
class HomeProviders extends StatelessWidget {
  const HomeProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SortViewModel()),
        ChangeNotifierProvider(create: (_) => ApplyQuotaViewModel()),
        ChangeNotifierProvider(create: (_) => MineViewModel()),
      ],
      child: const HomePage(),
    );
  }
}
