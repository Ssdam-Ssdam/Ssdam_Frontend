import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InquiryScreen extends StatefulWidget {
  final VoidCallback onNavigateBack; // HomeScreen으로 돌아가는 콜백

  const InquiryScreen({super.key, required this.onNavigateBack});

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String selectedValue = '전체'; // 드롭다운 초기값
  List<Map<String, dynamic>> inquiries = []; // 문의 데이터 리스트

  @override
  void initState() {
    super.initState();
    _fetchInquiries(); // 문의 데이터 로드
  }

  // 서버에서 문의 데이터 가져오기
  Future<void> _fetchInquiries() async {
    final String url = "http://10.0.2.2:3000/inquiry/view-all"; // 서버 URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // JSON 데이터 파싱
        setState(() {
          inquiries = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print("문의 데이터를 가져오지 못했습니다. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNavigateBack, // HomeScreen으로 돌아가기
                  child: Image.asset(
                    'assets/backbutton.png', // backbutton.png 파일 경로를 맞추세요
                    height: 40,
                  ),
                ),
                Spacer(),
                Text(
                  '1:1 문의',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // 문의하기 버튼 동작 정의
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
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      underline: SizedBox(),
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
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // 문의 목록
            Expanded(
              child: inquiries.isEmpty
                  ? Center(
                child: Text(
                  '문의 내역이 없습니다.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: inquiries.length,
                itemBuilder: (context, index) {
                  final inquiry = inquiries[index];
                  return Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    inquiry['created_at'], // 생성 날짜
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFB6B6B6),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // 상태 버튼 동작 정의
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                          color: Color(0xFFD9D9D9)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      minimumSize: Size(78, 31),
                                    ),
                                    child: Text(
                                      index % 2 == 0
                                          ? '진행중'
                                          : '답변완료', // 상태
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: index % 2 == 0
                                            ? Color(0xFFCDB72A) // 진행중
                                            : Color(0xFF25A52D), // 답변완료
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Text(
                                inquiry['title'], // 제목
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
