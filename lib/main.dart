import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // LoginScreen 경로를 맞추세요

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: '쓰담쓰담', // 앱 제목
      theme: ThemeData(
        fontFamily: "Pretendard"
      ),
      home: LoginScreen(), // LoginScreen 호출
    );
  }
}
