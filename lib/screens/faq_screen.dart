import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  final VoidCallback onNavigateBack; // HomeScreen으로 돌아가는 콜백

  const FAQScreen({super.key, required this.onNavigateBack});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faqs = [
    {
      'question': '설정한 집 주소를 변경하려면 어떻게 해야 하나요?',
      'answer': '설정 메뉴에서 주소를 변경할 수 있습니다.'
    },
    {
      'question': '사진이 인식되지 않아요.',
      'answer': '카메라 권한을 확인하거나 사진을 다시 업로드해주세요.'
    },
    {
      'question': '수수료 항목에 없는 물건은 어떻게 처리하나요?',
      'answer': '고객센터로 문의해주세요.'
    },
    {
      'question': '더 이상 생각 안 남. 어쩌구...',
      'answer': '시스템 관리자에게 문의해주세요.'
    },
    {
      'question': '회원탈퇴를 하고 싶어요.',
      'answer': '설정 메뉴에서 회원탈퇴를 진행할 수 있습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
      body: Column(
        children: [
          // 상단바 역할
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // 뒤로 가기 버튼 (왼쪽 정렬)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onNavigateBack, // HomeScreen으로 돌아가기
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
                    '자주 묻는 질문',
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
          // FAQ 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.white, // Card 배경색 설정
                  child: ExpansionTile(
                    title: Text(
                      faqs[index]['question']!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faqs[index]['answer']!,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}