import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool isEditing = false; // 현재 프로필 수정 화면인지 여부

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // 프로필 정보 로드
  }

  // 프로필 정보 조회 (GET 요청)
  Future<void> _fetchProfile() async {
    final String url = "http://10.0.2.2:3000/profile"; // Node.js 서버 URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          _userIdController.text = responseBody['userId'];
          _passwordController.text = responseBody['password'];
          _nameController.text = responseBody['name'];
          _emailController.text = responseBody['email'];
        });
      } else {
        print("프로필 정보를 가져오지 못했습니다. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }

// 프로필 정보 수정 (PUT 요청)
  Future<void> _updateProfile() async {
    final String url = "http://10.0.2.2:3000/profile/update"; // Node.js 서버 URL

    final String userId = _userIdController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "password": password,
          "name": name,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        print("프로필 정보가 성공적으로 업데이트되었습니다.");
        setState(() {
          isEditing = false; // 수정 화면에서 프로필 화면으로 전환
        });
        _fetchProfile(); // 업데이트 후 프로필 정보 다시 로드
      } else {
        print("프로필 수정 실패. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }

  // 프로필 화면 위젯
  Widget buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = true; // 수정 화면으로 전환
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFD9D9D9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '프로필 수정',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('분석 결과 조회 클릭');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFD9D9D9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '분석 결과 조회',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // 수정 화면 위젯
  Widget buildEditProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            'EDIT PROFILE',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _userIdController, // userId 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController, // password 컨트롤러 연결
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController, // name 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController, // email 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '이메일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _updateProfile, // 프로필 수정 버튼 클릭 시 API 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '수정하기',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 항상 표시되는 공통 헤더
                    Center(
                      child: Text(
                        'MY PROFILE',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    isEditing ? buildEditProfileView() : buildProfileView(),
                  ],
                ),
              ),
            ),
          ),
          // 로그아웃 버튼은 프로필 화면에서만 표시
          if (!isEditing)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('로그아웃 클릭');
                      Navigator.pop(context); // 이전 화면으로 돌아가기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFFD9D9D9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(120, 40),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
