import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // login_screen.dart 파일 불러오기

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 비활성화
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.green, // 앱 전체 테마 색상
      ),
      home: LoginScreen(), // 초기 화면을 LoginScreen으로 설정
    );
  }
}
