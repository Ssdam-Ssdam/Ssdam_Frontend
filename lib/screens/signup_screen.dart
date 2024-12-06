import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_screen.dart'; // LoginScreen 경로를 맞추세요

class SignupScreen extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController(); // 아이디 컨트롤러
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 컨트롤러
  final TextEditingController _nameController = TextEditingController(); // 이름 컨트롤러
  final TextEditingController _emailController = TextEditingController(); // 이메일 컨트롤러

  Future<void> _register(BuildContext context) async {
    final String url = "http://10.0.2.2:3000/register"; // Node.js 서버 URL
    final String userId = _userIdController.text; // 아이디 입력값 가져오기
    final String password = _passwordController.text; // 비밀번호 입력값 가져오기
    final String name = _nameController.text; // 이름 입력값 가져오기
    final String email = _emailController.text; // 이메일 입력값 가져오기

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "password": password,
          "name": name,
          "email": email,
        }),
      );

      if (response.statusCode == 201) {
        // 회원가입 성공 시 로그인 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        // 서버 응답에 따른 실패 처리
        final responseBody = json.decode(response.body);
        _showErrorDialog(context, responseBody['message'] ?? "회원가입에 실패했습니다.");
      }
    } catch (error) {
      // 네트워크 오류 처리
      _showErrorDialog(context, "네트워크 오류가 발생했습니다.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("회원가입 실패"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 나타날 때 화면 크기 조정
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // 스크롤 가능하도록 전체 감싸기
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // 양옆 여백 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40), // 상단 여백 추가
              // 앱 로고 및 타이틀
              Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // 아이디 입력 필드
              TextField(
                controller: _userIdController, // userId 컨트롤러
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

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController, // password 컨트롤러
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

              // 이름 입력 필드
              TextField(
                controller: _nameController, // name 컨트롤러
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

              // 이메일 입력 필드
              TextField(
                controller: _emailController, // email 컨트롤러
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
              SizedBox(height: 30),

              // 가입 버튼
              ElevatedButton(
                onPressed: () => _register(context), // 가입 버튼 클릭 시 API 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF599468),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  '가입',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
