import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';

import 'main_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String userId = _userIdController.text;
    final String password = _passwordController.text;

    // 입력값 검증
    if (userId.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "아이디와 비밀번호를 모두 입력해주세요.");
      return; // 서버 요청을 중단
    }

    final String url = "http://3.38.250.18:3000/user/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"userId": userId, "password": password}),
      );

      // 디버깅용 로그 추가
      print('Request sent to: $url');
      print('Request body: ${jsonEncode({"userId": userId, "password": password})}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // 서버에서 name과 token 값이 포함된 경우 로그인 성공
        if (responseBody.containsKey('name') && responseBody.containsKey('token')) {
          await SecureStorageUtil.saveToken(responseBody['token']); // 토큰 저장
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        } else {
          _showErrorDialog(context, "로그인 정보가 유효하지 않습니다.");
        }
      } else {
        _showErrorDialog(context, "아이디나 비밀번호가 일치하지 않습니다.");
      }
    } catch (error) {
      _showErrorDialog(context, "네트워크 오류 발생: $error");
    }
  }
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("로그인 실패"),
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
      resizeToAvoidBottomInset: true, // 키보드가 나타날 때 화면 크기를 조정
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            // 키보드로 인해 오버플로우 방지
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 로그인 제목
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),

                // 아이디 입력 필드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0), // 양옆 여백
                  child: TextField(
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
                ),
                SizedBox(height: 20),

                // 비밀번호 입력 필드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0), // 양옆 여백
                  child: TextField(
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
                ),
                SizedBox(height: 30),

                // 아이디/비밀번호 찾기 텍스트
                GestureDetector(
                  onTap: () {
                    // 아이디/비밀번호 찾기 클릭 이벤트 처리
                  },
                  child: Text(
                    '아이디 혹은 비밀번호를 잊으셨나요?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 80),

                // 로그인 및 회원가입 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 로그인 버튼
                    ElevatedButton(
                      onPressed: () => _login(context), // 서버와 연결
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF599468),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(140, 40),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: () {
                        // 회원가입 버튼 클릭 시 SignupScreen으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF599468),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(140, 40),
                      ),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
