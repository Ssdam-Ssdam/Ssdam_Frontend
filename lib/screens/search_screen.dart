import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
                        // 갤러리와 카메라 버튼을 컨테이너로 변경
                        Expanded(
                          child: Column(
                            children: [
                              // 갤러리 버튼 (기능 없음)
                              InkWell(
                                onTap: () {
                                  // 갤러리 버튼 클릭 시 아무 동작도 하지 않음
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('기능 미지원'),
                                      content: Text('갤러리 버튼은 비활성화되었습니다.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('확인'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
                              // 카메라 버튼 (기능 유지)
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
                        // 수수료 찾기 버튼 오른쪽 정렬
                        Container(
                          width: 150,
                          height: 120,
                          margin: EdgeInsets.only(right: 20), // 오른쪽에 20px 여백 추가
                          child: InkWell(
                            onTap: () {
                              if (_selectedImage == null) {
                                print('No image selected');
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
                              } else {
                                widget.onNavigateToResult(_selectedImage);
                              }

                            },
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
