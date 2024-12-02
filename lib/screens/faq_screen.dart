import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '자주 묻는 질문',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }
}
