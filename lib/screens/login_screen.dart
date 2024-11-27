import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로그인 제목
              Text(
                'Login',
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
                decoration: InputDecoration(
                  hintText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),

              // 비밀번호 입력 필드
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),

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
              SizedBox(height: 30),

              // 로그인 및 회원가입 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      print('로그인 버튼 클릭');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // primary 대신 backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(120, 50),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // 회원가입 버튼
                  ElevatedButton(
                    onPressed: () {
                      print('회원가입 버튼 클릭');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // primary 대신 backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(120, 50),
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
