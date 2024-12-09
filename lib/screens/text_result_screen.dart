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
                  fontSize: 20,
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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('${waste['waste_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('지역: ${waste['region']} ${waste['sub_region']}'),
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
        ],
      ),
    );
  }
}
