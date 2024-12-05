import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_profile_screen.dart';
import 'search_screen.dart';
import 'inquiry_screen.dart';
import 'faq_screen.dart';
import 'result_screen.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Widget _currentScreen = HomeScreen(
    onNavigateToInquiry: () {},
    onNavigateToFAQ: () {}, // 초기화
  );

  @override
  void initState() {
    super.initState();
    _currentScreen = HomeScreen(
      onNavigateToInquiry: _navigateToInquiryScreen,
      onNavigateToFAQ: _navigateToFAQScreen,
    );
  }

  // 고객 문의 화면으로 이동
  void _navigateToInquiryScreen() {
    setState(() {
      _currentScreen = InquiryScreen();
    });
  }

  // FAQ 화면으로 이동
  void _navigateToFAQScreen() {
    setState(() {
      _currentScreen = FAQScreen();
    });
  }

  // ResultScreen으로 이동
  void _navigateToResultScreen(File? image) {
    if (image == null) {
      print('No image provided to ResultScreen');
      return;
    }
    setState(() {
      _currentScreen = ResultScreen(image: image);
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
            onNavigateToResult: _navigateToResultScreen,
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
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/logo.png',
          height: 28,
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF5F5F5F)),
      ),
      body: _currentScreen,
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
        onTap: _onItemTapped,
      ),
    );
  }
}
