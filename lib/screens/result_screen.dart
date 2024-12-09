import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';
import 'main_screen.dart';


class ResultScreen extends StatefulWidget {
  final File? image;
  final String wasteName;
  final double accuracy;
  final String imageUrl;
  final String imgId;
  final String userId;

  ResultScreen({
    required this.image,
    required this.wasteName,
    required this.accuracy,
    required this.imageUrl,
    required this.imgId,
    required this.userId,
  });

  //widget.accuracy => 정확도 widget.wasteName => 폐기물이름

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLike = false; // 좋아요 상태
  bool _showAlternativeInput = false; // 싫어요 시 대체 입력 표시 여부
  bool _isButtonClicked = false; // 좋아요/싫어요 버튼 클릭 여부
  String? _wasteName; // 서버에서 받아온 폐기물 이름
  double? _accuracy; // 서버에서 받아온 정확도
  String? _imgId;
  String? _errorMessage;
  List<Map<String, dynamic>> _wasteFees = []; // waste_fees 데이터 저장 리스트


  @override
  void initState() {
    super.initState();
    _fetchWasteData();
  }

  // 서버에서 waste_name과 accuracy를 가져오기
  Future<void> _fetchWasteData() async {
    final String url = "http://10.0.2.2:3000/lar-waste/upload"; // 서버 URL

    if (widget.image == null) {
      setState(() {
        _errorMessage = "이미지가 없습니다.";
      });
      return;
    }

    try {
      final token = await SecureStorageUtil.getToken(); // 저장된 토큰 가져오기

      final request = http.MultipartRequest('POST', Uri.parse(url));

      // 토큰 헤더 추가
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      // 이미지 추가
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploadFile', // 서버에서 받을 필드 이름
          widget.image!.path,
        ),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = jsonDecode(responseData.body);

        print("서버 응답 데이터: $data");
        print("imgId 값: ${data['imgId'].toString()}");


        // JSON 데이터에서 waste_name과 accuracy를 가져와 UI에 반영
        setState(() {
          _wasteName = data['waste_name'];
          _accuracy = data['accuracy'];
          _imgId = data['imgId'].toString(); // 이미지 ID를 문자열로 저장
          _wasteFees = List<Map<String, dynamic>>.from(data['waste_fees'].map((fee) {
            return {
              'waste_standard': fee['waste_standard'],
              'fee': fee['fee'],
            };
          }));
        });
      } else {
        setState(() {
          _errorMessage = "결과를 불러올 수 없습니다. 상태 코드: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "네트워크 오류: $error";
      });
    }
  }


  Future<void> _sendFeedback(int isGood) async {
    final String url = "http://10.0.2.2:3000/lar-waste/feedback"; // 서버 URL

    try {
      final token = await SecureStorageUtil.getToken(); // 저장된 토큰 가져오기

      print('imgId : $_imgId');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // 토큰 추가
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'imgId': _imgId, // 이미지 ID 전달**fix**
          'is_good': isGood, // 좋아요/싫어요 상태 전달
          'waste_name': _wasteName, // 폐기물 이름 전달
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _showAlert("피드백이 성공적으로 전송되었습니다!");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
                (route) => false, // 기존 화면 제거
          );
        });
      } else {
        _showAlert("피드백 전송 실패. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      _showAlert("네트워크 오류: $error");
    }
  }


  void _showAlert(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });
  }


  void _handleSubmit() {
    if (!_isButtonClicked) {
      // 좋아요/싫어요 버튼을 누르지 않은 경우
      _showAlert('좋아요 또는 싫어요 버튼을 눌러주세요!');
    } else {
      final int isGood = _isLike ? 1 : 0; // 좋아요: 1, 싫어요: 0
      _sendFeedback(isGood); // 서버로 피드백 전송
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
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
                      '대형폐기물은 <$_wasteName> 입니다!', // "쇼파" 출력
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                    SizedBox(height: 20),
                    /*Text(
                      '정확도: ${_accuracy != null ? (_accuracy! * 100).toStringAsFixed(2) + '%': '정보 없음'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),*/
                    Text(
                      '결과 확인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.all(color: Colors.green),
                      children: [
                        // 헤더 행 추가
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '폐기물 기준',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '요금',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        // 데이터 행 추가
                        ..._wasteFees.map((fee) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(fee['waste_standard'], style: TextStyle(fontSize: 16)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${fee['fee']}원', style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      '결과에 만족하셨나요?',
                      style:
                      TextStyle(fontSize: 16, color: Color(0xFF6C6C6C)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: _isLike && _isButtonClicked
                                ? Color(0xFF6C6C6C) // 눌렀을 때 아이콘 색상
                                : Color(0xFFC7E5B5), // 디폴트 아이콘 색상 (하얀색)
                          ),
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
                        // 싫어요 버튼
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color: !_isLike && _isButtonClicked
                                ? Color(0xFF6C6C6C) // 눌렀을 때 아이콘 색상
                                : Color(0xFFC7E5B5), // 디폴트 아이콘 색상 (하얀색)
                          ),
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
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF5F5F5F)),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5), // 배경색 설정
                                    borderRadius:
                                    BorderRadius.circular(20), // 둥근 모서리
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16),
                                      hintText: '폐기물 종류 검색',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.search,
                                      color: Color(0xFF599468)),
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
