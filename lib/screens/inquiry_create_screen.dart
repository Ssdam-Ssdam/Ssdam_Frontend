import 'package:flutter/material.dart';

class InquiryCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색 설정
      body: Padding(
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
                      onTap: () {
                        Navigator.pop(context); // 뒤로 가기 기능
                      },
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
            SizedBox(height: 20),
            Text(
              '제목',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '문의 제목을 입력하세요.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '내용',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: '문의 내용을 입력하세요.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 문의 접수 버튼 동작 추가
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('문의가 접수되었습니다.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '문의 접수',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
