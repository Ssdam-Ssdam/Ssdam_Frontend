import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_profile_screen.dart';
import 'search_screen.dart';
import 'inquiry_screen.dart';
import 'faq_screen.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'text_result_screen.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 현재 화면을 관리하는 변수
  Widget _currentScreen = HomeScreen(
    onNavigateToInquiry: () {},
    onNavigateToFAQ: () {},
    onNavigateToResult: (searchQuery) {},
  );

  @override
  void initState() {
    super.initState();
    // 초기 화면 설정
    _currentScreen = HomeScreen(
      onNavigateToInquiry: _navigateToInquiryScreen,
      onNavigateToFAQ: _navigateToFAQScreen,
      onNavigateToResult: _navigateToTextResultScreen, // 콜백 전달
    );
  }

  // TextResultScreen으로 이동
  void _navigateToTextResultScreen(List<Map<String, dynamic>> wastes) {
    setState(() {
      _currentScreen = TextResultScreen(
        wastes: wastes,
        onNavigateBack: () {
          setState(() {
            _currentScreen = HomeScreen(
              onNavigateToInquiry: _navigateToInquiryScreen,
              onNavigateToFAQ: _navigateToFAQScreen,
              onNavigateToResult: _navigateToTextResultScreen,
            );
          });
        },
      );
    });
  }


  // 고객 문의 화면으로 이동
  void _navigateToInquiryScreen() {
    setState(() {
      _currentScreen = InquiryScreen(
        onNavigateBack: () {
          setState(() {
            _currentScreen = HomeScreen(
              onNavigateToInquiry: _navigateToInquiryScreen,
              onNavigateToFAQ: _navigateToFAQScreen,
              onNavigateToResult: _navigateToTextResultScreen,
            );
          });
        },
      );
    });
  }

  // FAQ 화면으로 이동
  void _navigateToFAQScreen() {
    setState(() {
      _currentScreen = FAQScreen(
        onNavigateBack: () {
          setState(() {
            _currentScreen = HomeScreen(
              onNavigateToInquiry: _navigateToInquiryScreen,
              onNavigateToFAQ: _navigateToFAQScreen,
              onNavigateToResult: _navigateToTextResultScreen,
            );
          });
        },
      );
    });
  }

  // 검색 화면으로 이동
  void _navigateToSearchScreen() {
    setState(() {
      _currentScreen = SearchScreen(
        onScreenChange: (newScreen) {
          setState(() {
            _currentScreen = newScreen;
          });
        },
        onNavigateToResult: _navigateToResultScreen, // 결과 화면으로 이동 콜백 설정
      );
    });
  }

  // ResultScreen으로 이동 (SearchScreen에서 데이터를 전달받아 사용)
  void _navigateToResultScreen(File image, String wasteName, double accuracy, String imageUrl, String imgId, String userId, List<Map<String, dynamic>> wasteFees,  // Pass this as an argument
      ) {
    setState(() {
      _currentScreen = ResultScreen(
        image: image,
        wasteName: wasteName,
        accuracy: accuracy,
        imageUrl: imageUrl,
        imgId: imgId,
        userId: userId,
        wasteFees: wasteFees,  // wasteFees 전달
      );
    });
  }

  // 분석 결과 화면으로 이동
  void _navigateToHistoryScreen() {
    setState(() {
      _currentScreen = HistoryScreen();
    });
  }

  // 탭 선택 시 호출되는 메서드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
        // HomeScreen 초기화
          _currentScreen = HomeScreen(
            onNavigateToInquiry: _navigateToInquiryScreen,
            onNavigateToFAQ: _navigateToFAQScreen,
            onNavigateToResult: _navigateToTextResultScreen, // 콜백 추가
          );
          break;
        case 1:
        // 검색 화면
          _navigateToSearchScreen();
          break;
        case 2:
        // 마이페이지
          _currentScreen = MyProfileScreen(
            onNavigateToHistory: _navigateToHistoryScreen, // onNavigateToHistory 전달
          );
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
        iconTheme: const IconThemeData(color: Color(0xFF5F5F5F)),
      ),
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
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
