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
      'answer': '폐가전제품은 수수료 항목에 포함되지 않습니다. 가까운 지자체의 처리 방법을 확인해주세요'
    },
    {
      'question': '회원탈퇴를 하고 싶어요.',
      'answer': '일주일 뒤 회원 탈퇴를 진행해드리겠습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Column(
        children: [
          // 상단바 역할
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 30), // 상단 여백 30에서 8로 변경
            child: Stack(
              children: [
                // 뒤로 가기 아이콘 (왼쪽 정렬)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onNavigateBack, // HomeScreen으로 돌아가기
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0), // 왼쪽 여백 추가
                      child: Icon(
                        Icons.arrow_back, // 기본 안드로이드 뒤로가기 화살표 아이콘
                        color: Color(0xFF5F5F5F), // 색상 #5f5f5f 설정
                        size: 30, // 아이콘 크기 30
                      ),
                    ),
                  ),
                ),
                // 제목 텍스트 (가운데 정렬)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '자주 묻는 질문', // 텍스트 '자주 묻는 질문'으로 설정
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
          Divider(
            color: Color(0xFFD9D9D9),
            thickness: 1,
          ),
          // FAQ 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백만 유지
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0), // 카드 간격 좁히기
                  color: Colors.white, // Card 배경색 설정
                  child: ExpansionTile(
                    title: Text(
                      faqs[index]['question']!,
                      style: TextStyle(
                        fontSize: 16, // 질문 크기
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5F5F), // 질문 색상 변경
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faqs[index]['answer']!,
                          style: TextStyle(
                            fontSize: 16, // 답변 크기를 질문 크기와 동일하게 설정
                            color: Colors.black, // 답변 색상을 black으로 설정
                          ),
                          textAlign: TextAlign.left, // 텍스트 왼쪽 정렬
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
