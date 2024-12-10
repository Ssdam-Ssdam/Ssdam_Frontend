import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapWebScreen extends StatelessWidget {
  final VoidCallback onNavigateBack;

  MapWebScreen({required this.onNavigateBack});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.google.com/maps"));

    return Scaffold(
      appBar: AppBar(
        title: Text("우리 동네 지도"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onNavigateBack,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
