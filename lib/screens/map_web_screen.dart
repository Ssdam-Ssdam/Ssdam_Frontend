import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWebScreen extends StatelessWidget {
  final VoidCallback onNavigateBack;

  // 단일 생성자로 통합
  const MapWebScreen({
    Key? key,
    required this.onNavigateBack,
  }) : super(key: key);

  static final LatLng myLatLng = LatLng(37.5233273, 126.921252); // 지도 초기화 위치

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "우리 동네 지도",
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: myLatLng,
                zoom: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timelapse_outlined,
                  color: Colors.green,
                  size: 50.0,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('편의점!'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






/*
//google map
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

 */