import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView页面 - 用于显示网页内容，如用户协议、隐私协议等
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // 初始化WebView控制器
    _initializeWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('WebView started loading: $url');
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            debugPrint('WebView finished loading: $url');

            // 使用智能缩放适应屏幕
            await _setSmartZoom();

            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            // 忽略SSL错误，继续加载
            if (error.description.contains('SSL') == true ||
                error.description.contains('certificate') == true) {
              debugPrint('SSL error ignored, continuing...');
              return;
            }
            // 对于其他错误，停止加载状态
            setState(() {
              isLoading = false;
            });
          },
        ),
      );

    // 直接加载URL，不进行任何验证或拦截
    _loadUrl(widget.url);
  }

  void _loadUrl(String url) {
    try {
      final uri = Uri.parse(url);
      controller.loadRequest(uri);
    } catch (e) {
      debugPrint('Invalid URL: $url, error: $e');
      // 即使URL无效，也不要显示错误，让WebView自己处理
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 智能缩放网页以适应手机屏幕
  Future<void> _setSmartZoom() async {
    try {
      // 简单直接的缩放实现
      debugPrint('Applying zoom to WebView');

      // 适中的字体放大
      const String fontZoomCode = '''
        // 放大所有文本（适中比例）
        var elements = document.querySelectorAll('*');
        for (var i = 0; i < elements.length; i++) {
          var element = elements[i];
          var currentSize = window.getComputedStyle(element).fontSize;
          if (currentSize && !currentSize.includes('px')) continue;

          var sizeValue = parseFloat(currentSize);
          if (sizeValue > 0 && sizeValue < 16) {
            element.style.fontSize = (sizeValue * 1.3) + 'px';
          }
        }

        // 设置body字体为适中大小
        document.body.style.fontSize = '16px';

        console.log('Moderate font zoom applied');
      ''';

      await controller.runJavaScript(fontZoomCode);
      debugPrint('Font zoom applied');

      // 等待一下再应用整体缩放
      await Future.delayed(const Duration(milliseconds: 300));

      // 应用适中的整体缩放
      const String zoomCode = '''
        // 整体缩放（适中比例）
        var style = document.createElement('style');
        style.id = 'webview-zoom';
        style.innerHTML = '* { zoom: 1.1 !important; }';
        document.head.appendChild(style);

        console.log('Moderate overall zoom applied');
      ''';

      await controller.runJavaScript(zoomCode);
      debugPrint('Overall zoom applied');

    } catch (e) {
      debugPrint('Zoom failed: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18.sp,
            color: const Color(0xFF333333),
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/images/ic_black_back.png',
            width: 12.w,
            height: 18.h,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      '正在加载...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}