import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'viewmodels/login_viewmodel.dart';

/// 登录页面状态管理提供者
class LoginProviders extends StatelessWidget {
  const LoginProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 登录ViewModel
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
      ],
      child: const LoginPage(),
    );
  }
}