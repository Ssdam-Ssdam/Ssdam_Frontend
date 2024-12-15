import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위한 패키지

class InquiryDetailScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;
  final Map<String, dynamic> inquiryData;

  const InquiryDetailScreen({
    super.key,
    required this.onNavigateBack,
    required this.inquiryData,
  });

  @override
  _InquiryDetailScreenState createState() => _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends State<InquiryDetailScreen> {
  // 날짜 포맷 함수
  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate); // 원하는 형식으로 포맷
    } catch (e) {
      return '날짜 없음'; // 날짜 파싱 실패 시 기본 값
    }
  }

  // 삭제 요청 함수
  Future<void> _deleteInquiry() async {
    final String url = 'http://3.36.62.234:3000/inquiry/delete';
    final inquiryId = widget.inquiryData['inquiryId'];

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'inquiryId': inquiryId}),
      );

      if (response.statusCode == 200) {
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
                        '삭제되었습니다!',
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
    final inquiryData = widget.inquiryData;
    final questionTitle = inquiryData['title'] ?? '제목 없음';
    final questionDate = inquiryData['created_at'] != null
        ? formatDate(inquiryData['created_at']) // 날짜 포맷 적용
        : '날짜 없음';
    final questionContent = inquiryData['content'] ?? '문의 내용이 없습니다.';
    final answerContent = inquiryData['res_message'] ?? '곧 답변 드리겠습니다. 조금만 기다려주세요 :)';
    final resDate = inquiryData['res_date'] != null
        ? formatDate(inquiryData['res_date']) // 날짜 포맷 적용
        : '답변 날짜 없음';

    final isNoAnswer = answerContent == '곧 답변 드리겠습니다. 조금만 기다려주세요 :)';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단바
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 17),  // 상단 여백 30
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
                      '문의 내용',  // 텍스트 '문의 내용'으로 설정
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

            // 제목
            SizedBox(height: 10),
            Text(
              questionTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // 날짜
            Text(
              questionDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // 질문 내용
            Text(
              questionContent,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            // 답변 박스
            // 답변 박스
            Align(
              alignment: Alignment.centerRight,  // 오른쪽 정렬
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isNoAnswer ? Colors.grey[200] : Color(0xFFF0F9F0), // 답변 여부에 따라 배경색 설정
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isNoAnswer ? Colors.grey : Color(0xFF599468), // 글자 색도 조건부 변경
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      answerContent,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87, // 텍스트는 동일한 색상 유지
                      ),
                    ),
                    if (!isNoAnswer) // 답변이 있는 경우에만 답변 날짜 표시
                      SizedBox(height: 10),
                    if (!isNoAnswer)
                      Text(
                        "답변 날짜: $resDate",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            // 삭제 버튼
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: _deleteInquiry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF599468),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '삭제',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
