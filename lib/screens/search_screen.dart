import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final ValueChanged<Widget> onScreenChange; // 새 매개변수 추가
  final Function(File?) onNavigateToResult; // ResultScreen으로 이동하는 콜백

  SearchScreen({required this.onScreenChange, required this.onNavigateToResult});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _selectedImage;

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
      // 이미지가 선택되지 않았을 경우 처리
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('이미지 선택'),
          content: Text('이미지를 먼저 선택해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    final String url = "http://10.0.2.2:3000/upload"; // Node.js 서버 URL
    final request = http.MultipartRequest('POST', Uri.parse(url));

    try {
      // 이미지 파일 첨부
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // 서버에서 받을 필드 이름
          _selectedImage!.path,
        ),
      );

      // 요청 보내기
      final response = await request.send();

      if (response.statusCode == 200) {
        // 성공 처리
        print("이미지가 성공적으로 업로드되었습니다.");
        widget.onNavigateToResult(_selectedImage); // 결과 화면으로 이동
      } else {
        // 실패 처리
        print("이미지 업로드 실패. 상태 코드: ${response.statusCode}");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('업로드 실패'),
            content: Text('이미지 업로드에 실패했습니다. 상태 코드: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // 네트워크 오류 처리
      print("네트워크 오류: $error");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('업로드 실패'),
          content: Text('네트워크 오류가 발생했습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
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
                            borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 설정 (16px)
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
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
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
                              'assets/findbutton.png', // 여기에 버튼용 이미지 경로를 입력하세요
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
