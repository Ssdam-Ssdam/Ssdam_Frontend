import 'dart:convert';
import 'package:flutter/material.dart';
import '../secure_storage_util.dart'; // SecureStorageUtil import
import 'package:http/http.dart' as http;

class InquiryCreateScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;

  const InquiryCreateScreen({super.key, required this.onNavigateBack});

  @override
  _InquiryCreateScreenState createState() => _InquiryCreateScreenState();
}

class _InquiryCreateScreenState extends State<InquiryCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _submitInquiry() async {
    final String? token = await SecureStorageUtil.getToken();
    if (token == null) {
      // 토큰이 없을 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final String url = 'http://3.38.250.18:3000/inquiry/create'; // 실제 서버 URL로 변경
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Map<String, String> body = {
      'title': _titleController.text,
      'content': _contentController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String inquiryId = responseData['inquiryId'].toString(); // Integer → String 변환
        final String title = responseData['title'];
        final String content = responseData['content'];
        final String createdAt = responseData['created_at'];
        final bool resStatus = responseData['res_status']; // Boolean 처리

        // 성공 알림
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('접수되었습니다!'),
            //content: Text('문의 ID: $inquiryId\n접수일: $createdAt'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onNavigateBack(); // 이전 화면으로 이동
                },
                child: Text('확인'),
              ),
            ],
          ),
        );

        // 입력값 초기화
        _titleController.clear();
        _contentController.clear();
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러 발생: ${errorResponse['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 에러 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 16, bottom: 16, left:16, top:27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단바 역할
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.onNavigateBack,
                      child: Image.asset(
                        'assets/backbutton.png',
                        height: 40,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '1:1 문의 접수',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Color(0xFFD9D9D9), thickness: 1),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFB6B6B6)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '제목을 입력해 주세요',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 410,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFB6B6B6)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '문의 내용을 입력해 주세요',
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _submitInquiry,
                child: Container(
                  width: 104,
                  height: 49,
                  decoration: BoxDecoration(
                    color: Color(0xFF599468),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '문의 접수',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
