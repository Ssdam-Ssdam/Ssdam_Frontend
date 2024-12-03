import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebViewScreen extends StatefulWidget {
  @override
  _MapWebViewScreenState createState() => _MapWebViewScreenState();
}

class _MapWebViewScreenState extends State<MapWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('file:///android_asset/flutter_assets/assets/kakao_map.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 보기'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
