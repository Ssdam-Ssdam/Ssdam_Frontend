import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';

class MapWebScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;

  const MapWebScreen({
    Key? key,
    required this.onNavigateBack,
  }) : super(key: key);

  @override
  _MapWebScreenState createState() => _MapWebScreenState();
}

class _MapWebScreenState extends State<MapWebScreen> {
  final String serverUrl = 'http://13.124.47.191:3000/lar-waste/nearby-stores';
  LatLng? userLocation;
  List<Marker> storeMarkers = [];
  List<Map<String, dynamic>> storeData = [];

  @override
  void initState() {
    super.initState();
    fetchNearbyStores();
  }

  Future<void> fetchNearbyStores() async {
    try {
      String? token = await SecureStorageUtil.getToken();

      if (token == null) {
        throw Exception("토큰이 없습니다.");
      }

      final response = await http.get(
        Uri.parse(serverUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['user_lat'] == null || data['user_lon'] == null) {
          throw Exception('사용자 위치 정보가 누락되었습니다.');
        }

        setState(() {
          userLocation = LatLng(
            double.parse(data['user_lat']),
            double.parse(data['user_lon']),
          );

          storeData = List<Map<String, dynamic>>.from(data['locations']);

          storeMarkers = storeData.map<Marker>((location) {
            return Marker(
              point: LatLng(location['latitude'], location['longitude']),
              width: 40.0,
              height: 40.0,
              rotate: true,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => showStoreInfoDialog(location), // 클릭 이벤트 연결
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            );
          }).toList();
        });
      } else if (response.statusCode == 404) {
        print('오류 발생: ${response.body}');
        throw Exception('근처 데이터를 찾을 수 없습니다.');
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  void showStoreInfoDialog(Map<String, dynamic> store) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            store['판매소명'] ?? '알 수 없음',
            style: TextStyle(
              fontWeight: FontWeight.w600, // 텍스트를 w600// 로 설정
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('주소: ${store['주소'] ?? '정보 없음'}',
                style: TextStyle(
                  color: Color(0xFF599468),
                  fontSize: 16,
                ),
              ),
              Text(''),
              Text('나와의 거리: ${(store['distance'] as double).toStringAsFixed(2)} km',
                style: TextStyle(
                  color: Color(0xFF599468),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nearby Stores'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onNavigateBack,
        ),
      ),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: userLocation!,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 50.0,
                height: 50.0,
                rotate: true,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 50.0,
                ),
              ),
              ...storeMarkers,
            ],
          ),
        ],
      ),
    );
  }
}
