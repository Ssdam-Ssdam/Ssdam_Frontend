import 'package:flutter/material.dart';

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  // 드롭다운 초기값
  String selectedValue = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 이전 화면으로 이동
                  },
                  child: Image.asset(
                    'assets/backbutton.png', // backbutton.png 파일 경로를 맞추세요
                    height: 40,
                  ),
                ),
                Spacer(), // 왼쪽과 가운데 사이에 공간 추가
                Text(
                  '1:1 문의',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Spacer(), // 가운데와 오른쪽 사이에 공간 추가
                ElevatedButton(
                  onPressed: () {
                    // 버튼 동작 정의
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFFD9D9D9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(90, 42),
                  ),
                  child: Text(
                    '문의하기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20), // 아래 내용과의 간격
            Row(
              children: [
                // 드롭다운 버튼
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54), // 테두리
                      borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true, // 드롭다운 너비를 꽉 채우기
                      underline: SizedBox(), // 기본 밑줄 제거
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: <String>['전체', '내가 쓴 글']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 17),
                          ),
                        );
                      }).toList(),
                      icon: Icon(Icons.arrow_drop_down), // 드롭다운 아이콘
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // 문의 목록
            Expanded(
              child: ListView(
                children: [
                  // 문의 내용 1
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '2024.11.25 01:35',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB6B6B6),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Color(0xFFD9D9D9)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: Size(78, 31),
                                ),
                                child: Text(
                                  '진행중',
                                  style: TextStyle(fontSize: 15,color: Color(0xFFCDB72A)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7), // 날짜/버튼과 아래 텍스트 사이의 간격
                          Text(
                            '스티커 판매점 정보를 지도에서 확인하려면 어떻게 해야 하나요?',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  // 문의 내용 2
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '2024.10.30 15:35',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB6B6B6),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Color(0xFFD9D9D9)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: Size(78, 31),
                                ),
                                child: Text(
                                  '답변완료',
                                  style: TextStyle(fontSize: 15,color: Color(0xFF25A52D)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7), // 날짜/버튼과 아래 텍스트 사이의 간격
                          Text(
                            '폐가전 무상수거 링크가 클릭되지 않습니다.',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
