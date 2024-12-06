import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'result_screen.dart';
import '../secure_storage_util.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Widget>? onScreenChange; // 추가
  final Function(File, String, double, String, String)? onNavigateToResult; // 추가

  SearchScreen({
    this.onScreenChange, // 추가
    this.onNavigateToResult, // 추가
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _selectedImage;

  // 토큰 확인 메서드
  Future<void> checkToken() async {
    final token = await SecureStorageUtil.getToken();
    if (token == null) {
      print("토큰이 없습니다. 로그인 필요.");
    } else {
      print("저장된 토큰: $token");
    }
  }

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

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showAlert('이미지를 먼저 선택해주세요.');
      return;
    }

    final String url = "http://10.0.2.2:3000/lar-waste/upload";

    try {
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
        final Map<String, dynamic> data = json.decode(responseData.body);

        // 서버에서 예상치 못한 null 값이 올 경우 기본값 설정
        final wasteName = data['waste_name'] ?? 'Unknown';
        final accuracy = data['accuracy'] ?? 0.0;
        final imageUrl = data['image'] ?? '';
        final imgId = data['imgId'] ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              image: _selectedImage!,
              wasteName: wasteName,
              accuracy: accuracy,
              imageUrl: imageUrl,
              imgId: imgId,
            ),
          ),
        );
      } else {
        _showAlert('이미지 업로드 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (error) {
      _showAlert('네트워크 오류: $error');
    }
  }



  // 알림창 표시 메서드
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                // 이미지 업로드 및 결과 보기
                Column(
                  children: [
                    if (_selectedImage != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 설정
                            child: Image.file(
                              _selectedImage!,
                              height: 310,
                              width: 340,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    else
                      Container(
                        width: 310,
                        height: 340,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF599468)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '이미지를 업로드하고 수수료 찾기 버튼을 클릭하세요',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // 갤러리 버튼
                              InkWell(
                                onTap: () => _pickImage(ImageSource.gallery),
                                child: Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo,
                                          color: Color(0xFF599468), size: 30),
                                      SizedBox(height: 8),
                                      Text(
                                        '갤러리',
                                        style: TextStyle(
                                          color: Color(0xFF5F5F5F),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // 카메라 버튼
                              InkWell(
                                onTap: () => _pickImage(ImageSource.camera),
                                child: Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt,
                                          color: Color(0xFF599468), size: 30),
                                      SizedBox(height: 8),
                                      Text(
                                        '카메라',
                                        style: TextStyle(
                                          color: Color(0xFF5F5F5F),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        // 수수료 찾기 버튼
                        Container(
                          width: 150,
                          height: 120,
                          child: InkWell(
                            onTap: _uploadImage, // 서버로 이미지 업로드
                            child: Image.asset(
                              'assets/findbutton.png', // 버튼 이미지
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
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
