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

    final String url = "http://3.38.250.18:3000/lar-waste/upload";

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
      }
    } catch (error) {
      _showAlert('네트워크 오류: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16, left:16, top:25),
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
                        width: 290,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),  // Lighter gray color
                          border: Border.all(
                              color: Color(0xFF599468)),
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
                                fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => _pickImage(ImageSource.gallery),
                                child: Container(
                                  width: 120,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFF599468)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo,
                                          color: Color(0xFF599468), size: 41),
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
                              SizedBox(height: 22),
                              InkWell(
                                onTap: () => _pickImage(ImageSource.camera),
                                child: Container(
                                  width: 120,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFF599468)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Color(0xFF599468), size: 40),
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
                        ),
                        Container(
                          width: 135,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFF599468),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 아이콘이 아래로, 텍스트가 위로 배치되도록 설정
                            children: [
                              RichText(
                                textAlign: TextAlign.center, // 텍스트 중앙 정렬
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '나의 대형 폐기물\n', // 첫 번째 텍스트 부분
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '수수료', // "수수료" 부분
                                      style: TextStyle(
                                        fontSize: 21, // 글자 크기 키움
                                        color: Color(0xFF599468), // 색상 지정
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' 찾기', // 나머지 텍스트 부분
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8), // 텍스트와 아이콘 사이의 간격
                              Icon(
                                Icons.attach_money,
                                color: Color(0xFF599468),
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 35), // Row 전체 여백 조정
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