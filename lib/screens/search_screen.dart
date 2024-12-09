import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'result_screen.dart';
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
        print('Response Body: ${responseData.body}');
        final Map<String, dynamic> data = json.decode(responseData.body);
        print('Parsed Data: $data');
        // 콜백 호출로 ResultScreen으로 이동
        if (widget.onNavigateToResult != null) {
          final Map<String, dynamic> data = json.decode(responseData.body);

          String wasteName = data['waste_name'] ?? 'Unknown';
          double accuracy = data['accuracy'] ?? 0.0;
          String imageUrl = data['image'] ?? '';
          String imgId = (data['imgId'] ?? '').toString();
          String userId = (data['userId'] ?? '').toString();
          List<Map<String, dynamic>> wasteFees = List<Map<String, dynamic>>.from(data['waste_fees']);

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
      backgroundColor: Colors.white,
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
                Column(
                  children: [
                    if (_selectedImage != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
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
                              InkWell(
                                onTap: () => _pickImage(ImageSource.gallery),
                                child: Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFF599468)),
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
                              InkWell(
                                onTap: () => _pickImage(ImageSource.camera),
                                child: Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFF599468)),
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
                        Container(
                          width: 150,
                          height: 120,
                          child: InkWell(
                            onTap: _uploadImage,
                            child: Image.asset(
                              'assets/findbutton.png',
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