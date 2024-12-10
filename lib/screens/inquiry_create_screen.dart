import 'package:flutter/material.dart';

class InquiryCreateScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;

  const InquiryCreateScreen({super.key, required this.onNavigateBack});

  @override
  _InquiryCreateScreenState createState() => _InquiryCreateScreenState();
}

class _InquiryCreateScreenState extends State<InquiryCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단바 역할
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                  // 뒤로 가기 버튼 (왼쪽 정렬)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.onNavigateBack, // 뒤로가기 콜백 호출
                      child: Image.asset(
                        'assets/backbutton.png', // backbutton.png 파일 경로 확인 필요
                        height: 40,
                      ),
                    ),
                  ),
                  // 제목 텍스트 (가운데 정렬)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '1:1 문의 접수',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xFFD9D9D9),
              thickness: 1,
            ),
            SizedBox(height: 40),
            // 제목 입력칸
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
            // 내용 입력칸
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            // 문의 접수 버튼
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // 버튼 클릭 시 동작 처리 (예: 문의 접수 제출)
                },
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
                        fontWeight: FontWeight.bold,
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


