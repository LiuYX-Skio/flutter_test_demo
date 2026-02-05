import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/main_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/sort_viewmodel.dart';
import 'viewmodels/apply_quota_viewmodel.dart';
import 'viewmodels/mine_viewmodel.dart';
import 'main_page.dart';

/// Home模块的Provider包装器
/// 提供所有ViewModel的依赖注入
class HomeProviders extends StatelessWidget {
  const HomeProviders({Key? key}) : super(key: key);

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
      child: const MainPage(),
    );
  }
}
