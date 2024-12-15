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

    final String url = 'http://3.36.62.234:3000/inquiry/create'; // 실제 서버 URL로 변경
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

        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // 알림창 모서리 둥글게 설정
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 80, maxWidth: 250), // 크기 제한
              child: Stack(
                children: [
                  // 텍스트 (중앙에 배치)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8), // 텍스트 좌우 여백 최소화
                      child: Text(
                        '접수되었습니다!',
                        style: TextStyle(
                          fontSize: 16, // 텍스트 크기 약간 축소
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F5F5F),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 닫기 버튼 ('X'를 우측 상단에 배치)
                  Positioned(
                    top: 4, // 위쪽 여백 최소화
                    right: 4, // 오른쪽 여백 최소화
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFF8A2BE2), // 색상 설정
                        size: 16, // 아이콘 크기 축소
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onNavigateBack(); // 이전 화면으로 이동
                      },
                    ),
                  ),
                ],
              ),
            ),
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
        padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단바 역할
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 30),  // 상단 여백 30
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.onNavigateBack,
                      child: Icon(
                        Icons.arrow_back,  // 기본 안드로이드 뒤로가기 화살표 아이콘
                        color: Color(0xFF5F5F5F),  // 색상 #5f5f5f 설정
                        size: 30,  // 아이콘 크기 30
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '문의하기',  // 텍스트 '문의하기'로 설정
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
            SizedBox(height: 10),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFB6B6B6)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '문의 내용을 입력해 주세요', // "문의 내용" 텍스트로 변경
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF599468),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '저장하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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