import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../secure_storage_util.dart'; // SecureStorageUtil import

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _historyData = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    final url = Uri.parse('http://3.38.250.18:3000/user/history'); // 서버 URL
    try {
      final token = await SecureStorageUtil.getToken();
      if (token == null) {
        throw Exception('Token not found. Please log in.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // 올바른 키 사용: history_data
          _historyData = List<Map<String, dynamic>>.from(data['history_data']);
        });
      } else {
        throw Exception('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _historyData.isEmpty
                ? const Center(
              child: Text(
                '데이터가 없습니다.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'AI 분석 결과',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._historyData.map((waste) {
                  final wasteName = waste['waste_name'];
                  final wasteFee = waste['waste_fee'] as List<dynamic>;
                  final filePath = waste['file_path'];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF599468)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 왼쪽: 이미지와 폐기물 이름
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,                          children: [
                          if (filePath != null)
                            ClipRRect(
                              //borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'http://3.38.250.18:3000$filePath',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            wasteName ?? '알 수 없는 폐기물',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5F5F5F),
                            ),
                          ),
                        ],
                        ),
                        const SizedBox(width: 20), // 왼쪽과 오른쪽 간격
                        // 오른쪽: 표
                        Expanded( // 오른쪽 표를 유연하게 크기를 조정
                          child: Table(
                            //border: TableBorder.all(color: Colors.green, width: 0.5), // 테두리 두께
                            children: [
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.0), // 패딩 줄이기
                                    child: Text(
                                      '폐기물 기준',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // 텍스트 크기 줄이기
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      '요금',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              ...wasteFee.map((fee) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0), // 패딩 줄이기
                                      child: Text(
                                        fee['waste_standard'] ?? '기준 없음',
                                        style: const TextStyle(fontSize: 14), // 텍스트 크기 줄이기
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        '${fee['fee']}원',
                                        style: const TextStyle(fontSize: 14), // 텍스트 크기 줄이기
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}