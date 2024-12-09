import 'package:flutter/material.dart';

class TextResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> wastes; // wastes 데이터
  final VoidCallback onNavigateBack;

  const TextResultScreen({
    super.key,
    required this.wastes, // wastes 데이터를 필수로 받음
    required this.onNavigateBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
      body: Column(
        children: [
          // 검색 결과 텍스트
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '검색 결과',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Expanded(
            child: wastes.isEmpty
                ? Center(
              child: Text(
                '검색 결과가 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wastes.length,
              itemBuilder: (context, index) {
                final waste = wastes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색 흰색
                    border: Border.all(color: Color(0xFF599468), width: 2),
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  ),
                  child: ListTile(
                    tileColor: Colors.white, // ListTile의 배경색
                    title: Text('${waste['waste_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text('지역: ${waste['region']} ${waste['sub_region']}'),
                        Text('분류: ${waste['waste_category']}'),
                        Text('규격: ${waste['waste_standard']}'),
                        Text('수수료: ${waste['fee']}원'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onNavigateBack, // 돌아가기 버튼 클릭 시 onNavigateBack 실행
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(120, 40),
                  ),
                  child: Text(
                    '돌아가기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}