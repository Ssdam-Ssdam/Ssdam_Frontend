import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final File? image;

  ResultScreen({required this.image});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLike = false; // 좋아요 상태
  bool _showAlternativeInput = false; // 싫어요 시 대체 입력 표시 여부
  bool _isButtonClicked = false; // 좋아요/싫어요 버튼 클릭 여부

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_isButtonClicked) {
      // 좋아요/싫어요 버튼을 누르지 않은 경우
      _showAlert('좋아요 또는 싫어요 버튼을 눌러주세요!');
    } else {
      // 이전 화면으로 돌아가기
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'AI 분석 결과',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),
                widget.image != null
                    ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        widget.image!,
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'OOO님의 대형폐기물은 OO 입니다!',
                      style: TextStyle(fontSize: 18, color: Color(0xFF5F5F5F)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '결과 확인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('장롱', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('가로 50cm 이하, 세로 50cm 이하       1,000원'),
                          Text('가로 50cm 이하, 세로 100cm 이하      2,000원'),
                          Text('가로 90cm 이하, 세로 110cm 이하      3,000원'),
                          Text('가로 100cm 이하, 세로 150cm 이하     5,000원'),
                          Text('가로 100cm 이하, 세로 180cm 이하     7,000원'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '결과에 만족하셨나요?',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6C6C6C)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: Color(0xFF5F5F5F)),
                          iconSize: 35,
                          onPressed: () {
                            setState(() {
                              _isLike = true;
                              _isButtonClicked = true;
                              _showAlternativeInput = false;
                            });
                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: Color(0xFF5F5F5F)),
                          iconSize: 35,
                          onPressed: () {
                            setState(() {
                              _isLike = false;
                              _isButtonClicked = true;
                              _showAlternativeInput = true;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (_showAlternativeInput)
                      Column(
                        children: [
                          Text(
                            'AI가 분류한 결과가 아닌가요?',
                            style: TextStyle(fontSize: 18, color: Color(0xFF5F5F5F)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5), // 배경색 설정
                                    borderRadius: BorderRadius.circular(20), // 둥근 모서리
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                      hintText: '폐기물 종류 검색',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.search, color: Color(0xFF599468)),
                                  iconSize: 28,
                                  onPressed: () {
                                    // 검색 버튼 클릭 시 동작
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    else
                      SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFFD9D9D9)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: Size(120, 40),
                          ),
                          child: Text(
                            '제출하기',
                            style: TextStyle(color: Color(0xFF000000)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : Text(
                  '이미지가 없습니다.',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
