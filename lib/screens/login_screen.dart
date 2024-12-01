import 'package:flutter/material.dart';
import 'main_screen.dart'; // MainScreen 경로를 맞추세요
import 'signup_screen.dart'; // SignupScreen 경로를 맞추세요

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 나타날 때 화면 크기를 조정
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView( // 키보드로 인해 오버플로우 방지
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 로그인 제목
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),

                // 아이디 입력 필드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0), // 양옆 여백
                  child: TextField(
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
                    print('아이디 혹은 비밀번호를 잊으셨나요?');
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
                      onPressed: () {
                        // 로그인 버튼 클릭 시 MainScreen으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF599468), // primary 대신 backgroundColor
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(140, 40),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // 텍스트 색상을 흰색으로 설정
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
                        backgroundColor: Color(0xFF599468), // primary 대신 backgroundColor
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(140, 40),
                      ),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // 텍스트 색상을 흰색으로 설정
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
