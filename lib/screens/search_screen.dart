import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../secure_storage_util.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Widget>? onScreenChange; // 화면 전환 콜백
  final Function(File, String, double, String, String, String, List<Map<String, dynamic>> wasteFees)? onNavigateToResult; // 결과 화면 이동 콜백

  SearchScreen({
    this.onScreenChange,
    this.onNavigateToResult,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _selectedImage;
  bool isLoading = false; // 로딩 상태를 추적하는 변수

  // 이미지 선택 메서드
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 이미지 업로드 및 결과 화면으로 이동
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showAlert('이미지를 먼저 선택해주세요.');
      return;
    }

    final String url = "http://3.36.62.234:3000/lar-waste/upload";

    try {
      setState(() {
        isLoading = true; // 업로드 시작 전에 로딩 상태 true로 설정
      });

      final token = await SecureStorageUtil.getToken();
      if (token == null) {
        _showAlert('로그인이 필요합니다.');
        return;
      }

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath(
          'uploadFile',
          _selectedImage!.path,
          contentType: MediaType('image', 'jpeg'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        print('Response Body: ${responseData.body}');
        final Map<String, dynamic> data = json.decode(responseData.body);
        print('Parsed Data: $data');

        Navigator.pop(context);

        // 콜백 호출로 ResultScreen으로 이동
        if (widget.onNavigateToResult != null) {
          final Map<String, dynamic> data = json.decode(responseData.body);

          String wasteName = data['waste_name'] ?? 'Unknown';
          double accuracy = data['accuracy'] ?? 0.0;
          String imageUrl = data['image'] ?? '';
          String imgId = (data['imgId'] ?? '').toString();
          String userId = (data['userId'] ?? '').toString();
          List<Map<String, dynamic>> wasteFees = List<
              Map<String, dynamic>>.from(data['waste_fees']);

          widget.onNavigateToResult!(
            _selectedImage!,
            wasteName,
            accuracy,
            imageUrl,
            imgId,
            userId,
            wasteFees, // Passing the wasteFees data
          );
        }
      } else {
        _showAlert('이미지 업로드 실패: 상태 코드 ${response.statusCode}');
        Navigator.pop(context);  // 오류 발생 시에도 로딩 종료
      }
    } catch (error) {
      _showAlert('네트워크 오류: $error');
      Navigator.pop(context);  // 오류 발생 시에도 로딩 종료
    } finally {
      setState(() {
        isLoading = false; // 업로드가 끝나면 로딩 상태를 false로 설정
      });
    }
  }

  // 알림창 표시 메서드
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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

  // 이미지 분석 중 팝업
  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경 클릭 시 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 15),
              Text('이미지 분석 중...', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16, top: 20),
            child: Column(
              children: [
                Text(
                  '나의 대형 폐기물',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    if (_selectedImage != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedImage!,
                              width: 290,  // 이미지 컨테이너의 너비
                              height: 300, // 이미지 컨테이너의 높이
                              fit: BoxFit.cover, // 이미지 비율 유지하면서 컨테이너 크기에 맞게 잘림
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    else
                      Container(
                        width: 290,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),  // Lighter gray color
                          border: Border.all(color: Color(0xFF599468)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload,
                              color: Color(0xFF599468),
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '이미지 업로드',
                              style: TextStyle(
                                color: Color(0xFF5F5F5F),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _pickImage(ImageSource.gallery),
                          child: Container(
                            width: 135, // 상단 박스와 동일한 가로 길이
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFF599468)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo, color: Color(0xFF599468), size: 41),
                                SizedBox(height: 8),
                                Text(
                                  '갤러리',
                                  style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: () => _pickImage(ImageSource.camera),
                          child: Container(
                            width: 135, // 상단 박스와 동일한 가로 길이
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFF599468)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, color: Color(0xFF599468), size: 40),
                                SizedBox(height: 8),
                                Text(
                                  '카메라',
                                  style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    InkWell(
                      onTap: () {
                        _showProcessingDialog(); // 팝업 띄우기
                        _uploadImage();
                      },
                      child: Container(
                        width: 290, // 업로드 사진 박스와 동일한 가로 길이
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF599468), // 버튼 색상
                          borderRadius: BorderRadius.circular(20), // 둥글기 강조
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // 그림자 색상
                              blurRadius: 8, // 그림자의 흐림 정도
                              offset: Offset(2, 4), // 그림자 방향과 거리
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "나의 대형 폐기물 수수료 찾기",
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상
                                fontSize: 18,
                                fontWeight: FontWeight.w600, // 폰트 굵기를 w600으로 변경
                              ),
                            ),
                            SizedBox(width: 10), // 텍스트와 아이콘 간 간격
                            Icon(Icons.search, size: 27, color: Colors.white), // 아이콘 색상
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}