import 'package:flutter/material.dart';
import 'home_screen.dart'; // HomeScreen 경로를 맞추세요
import 'my_profile_screen.dart'; // MyProfileScreen 경로를 맞추세요

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 각 탭에서 보여줄 화면 목록
  final List<Widget> _screens = [
    HomeScreen(), // 홈 화면
    Center(child: Text('검색 화면')), // 검색 화면 (예제)
    MyProfileScreen(), // 마이페이지 화면
  ];

  // 탭 선택 시 호출되는 메서드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        title: Image.asset(
          'assets/logo.png',
          height: 28,
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: _screens[_selectedIndex], // 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // 탭 클릭 이벤트 처리
      ),
    );
  }
}
