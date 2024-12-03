import 'package:flutter/material.dart';
import 'package:p_project/screens/search_screen.dart';
import 'home_screen.dart'; // HomeScreen 경로를 맞추세요
import 'my_profile_screen.dart'; // MyProfileScreen 경로를 맞추세요
import 'inquiry_screen.dart'; // InquiryScreen 경로를 맞추세요
import 'faq_screen.dart'; // FAQScreen 경로를 맞추세요

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Widget _currentScreen = HomeScreen(
    onNavigateToInquiry: () {},
    onNavigateToFAQ: () {}, // 초기화
  ); // 기본값 설정

  @override
  void initState() {
    super.initState();
    // 초기 화면 설정
    _currentScreen = HomeScreen(
      onNavigateToInquiry: _navigateToInquiryScreen,
      onNavigateToFAQ: _navigateToFAQScreen,
    );
  }

  // 고객 문의 화면으로 이동
  void _navigateToInquiryScreen() {
    setState(() {
      _currentScreen = InquiryScreen(); // InquiryScreen을 표시
    });
  }

  // FAQ 화면으로 이동
  void _navigateToFAQScreen() {
    setState(() {
      _currentScreen = FAQScreen(); // FAQScreen을 표시
    });
  }

  // 탭 선택 시 호출되는 메서드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentScreen = HomeScreen(
            onNavigateToInquiry: _navigateToInquiryScreen,
            onNavigateToFAQ: _navigateToFAQScreen,
          );
          break;
        case 1:
          _currentScreen = SearchScreen(
            onScreenChange: (newScreen) {
              setState(() {
                _currentScreen = newScreen;
              });
            },
          );
          break;

        case 2:
          _currentScreen = MyProfileScreen();
          break;
      }
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
        iconTheme: IconThemeData(color: Color(0xFF5F5F5F)),
      ),
      body: _currentScreen, // 현재 화면 표시
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
        selectedItemColor: Color(0xFF599468),
        unselectedItemColor: Color(0xFF5F5F5F),
        onTap: _onItemTapped, // 탭 클릭 이벤트 처리
      ),
    );
  }
}
