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
  final List<Map<String, dynamic>> wasteFees; // Added wasteFees parameter
  final VoidCallback onNavigateToSearch; // SearchScreen으로 이동하는 콜백 추가

  ResultScreen({
    required this.image,
    required this.wasteName,
    required this.accuracy,
    required this.imageUrl,
    required this.imgId,
    required this.userId,
    required this.wasteFees,
    required this.onNavigateToSearch, // 콜백 초기화
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
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false; // 검색 로딩 상태

  @override
  void initState() {
    super.initState();
    _wasteName = widget.wasteName;
    _accuracy = widget.accuracy;
    _imgId = widget.imgId;

    try {
      _wasteFees = List<Map<String, dynamic>>.from(widget.wasteFees.map((fee) {
        return {
          'waste_standard': fee['waste_standard'],
          'fee': fee['fee'],
        };
      }));
    } catch (e) {
      _errorMessage = "폐기물 요금 정보를 불러오는 데 실패했습니다.";
    }
      // 정확도 체크 및 경고창 표시
      if (_accuracy != null && _accuracy! > 0.5405652467161417) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('알림'),
              content: Text('AI의 정확도가 낮습니다. 다시 분석하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNavigateToSearch(); // SearchScreen으로 이동
                  },
                  child: Text('예'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('아니요'),
                ),
              ],
            ),
          );
        });
      }
    }


    Future<void> _sendFeedback(int isGood) async {
    final String url = "http://3.38.250.18:3000/lar-waste/feedback"; // 서버 URL

    // 피드백을 보내기 전에 waste_name을 결정
    String feedbackWasteName = _wasteName!;  // 기본적으로 AI 분류 결과의 waste_name 사용

    // 싫어요가 클릭되었고 사용자가 검색한 결과가 있다면
    if (!_isLike && _searchResults.isNotEmpty) {
      feedbackWasteName = _searchResults[0]['waste_name'];
    }

    try {
      final token = await SecureStorageUtil.getToken(); // 저장된 토큰 가져오기

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // 토큰 추가
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'imgId': _imgId, // 이미지 ID 전달**fix**
          'is_good': isGood, // 좋아요/싫어요 상태 전달
          'waste_name': feedbackWasteName,
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

  Future<void> _searchWaste(String query) async {
    if (query.isEmpty) {
      print("검색어를 입력해주세요.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SecureStorageUtil.getToken();

      // URL에 검색어를 포함
      final Uri uri = Uri.parse('http://3.38.250.18:3000/lar-waste/search').replace(
        queryParameters: {
          'waste_name': query, // 검색어 추가
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final wastes = (responseBody['wastes'] as List)
            .map((item) => {
          'waste_name': item['waste_name'],
          'waste_standard': item['waste_standard'],
          'fee': item['fee'],
        })
            .toList();

        setState(() {
          _searchResults = wastes;
          _isLoading = false; // Add this to stop loading indicator
        });
      } else {
        setState(() {
          _isLoading = false; // Add this to stop loading indicator
        });
        _showAlert("검색 실패. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Add this to stop loading indicator
      });
      _showAlert("검색 중 오류가 발생했습니다: $error");
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
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
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
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '대형폐기물은 ', // 기본 텍스트
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5F5F5F), // 기본 색상
                            ),
                          ),
                          TextSpan(
                            text: '$_wasteName', // wasteName 텍스트
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF599468), // wasteName 색상 변경
                            ),
                          ),
                          TextSpan(
                            text: ' 입니다!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5F5F5F), // 기본 색상
                            ),
                          ),
                        ],
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF599468)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            // waste_name 출력
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$_wasteName',
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center, // 텍스트 중앙 정렬
                              ),
                            ),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                // 첫 번째 열은 두 번째 열보다 1.5 배로 넓음
                                1: FlexColumnWidth(1),
                                // 두 번째 열
                              },
                              children: [
                                // 데이터 행 추가
                                ..._wasteFees.map((fee) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Text(
                                          '   ${fee['waste_standard'] ?? '기준 없음'}',
                                          style: const TextStyle(
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20), // 오른쪽에만 여백 추가
                                        child: Text(
                                          '${fee['fee']}원',
                                          style: const TextStyle(
                                              fontSize: 16),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '결과에 만족하셨나요?',
                      style: TextStyle(
                          fontSize: 16, color: Color(0xFF6C6C6C)),
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
                    _showAlternativeInput
                        ? Column(
                      children: [
                        Text(
                          'AI가 분류한 결과가 아닌가요?',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF5F5F5F)),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5), // 배경색 설정
                                  borderRadius: BorderRadius.circular(
                                      20), // 둥근 모서리
                                ),
                                child: TextField(
                                  controller: _searchController,  // Bind the search controller
                                  decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.symmetric(
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
                                  _searchWaste(_searchController.text); // Start search
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _searchResults.isNotEmpty
                            ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_searchResults[index]
                              ['waste_name']),
                              subtitle: Text(
                                  '${_searchResults[index]['waste_standard']} : ${_searchResults[index]['fee']}원'),
                            );
                          },
                        )
                            : SizedBox(),
                      ],
                    )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
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
                        ],),),
                  ],
                )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
