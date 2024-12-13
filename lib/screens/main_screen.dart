import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_profile_screen.dart';
import 'search_screen.dart';
import 'inquiry_screen.dart';
import 'inquiry_create_screen.dart';
import 'inquiry_detail_screen.dart';
import 'faq_screen.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'text_result_screen.dart';
import 'dart:io';
import 'map_web_screen.dart';

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
    onNavigateToMap: () {}, // 추가
  );

  @override
  void initState() {
    super.initState();
    // 초기화면설정
    _currentScreen = HomeScreen(
      onNavigateToInquiry: _navigateToInquiryScreen,
      onNavigateToFAQ: _navigateToFAQScreen,
      onNavigateToResult: _navigateToTextResultScreen,
      onNavigateToMap: _navigateToMapScreen, // 추가
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
              onNavigateToMap: _navigateToMapScreen, // 추가
            );
          });
        },
      );
    });
  }

  // MapWebScreen 이동 메서드
  void _navigateToMapScreen() {
    setState(() {
      _currentScreen = MapWebScreen(
        onNavigateBack: () {
          setState(() {
            _currentScreen = HomeScreen(
              onNavigateToInquiry: _navigateToInquiryScreen,
              onNavigateToFAQ: _navigateToFAQScreen,
              onNavigateToResult: _navigateToTextResultScreen,
              onNavigateToMap: _navigateToMapScreen, // 콜백 전달
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
              onNavigateToMap: _navigateToMapScreen, // 추가
            );
          });
        },
        onNavigateToInquiryCreate: _navigateToInquiryCreateScreen, // 콜백 전달
        onNavigateToInquiryDetail: _navigateToInquiryDetailScreen, // 상세 페이지로 이동 콜백 전달
      );
    });
  }

  // InquiryCreateScreen으로 이동
  void _navigateToInquiryCreateScreen() {
    setState(() {
      _currentScreen = InquiryCreateScreen(
        onNavigateBack: _navigateToInquiryScreen, // InquiryScreen으로 돌아가는 콜백
      );
    });
  }

  // InquiryDetailScreen으로 이동
  void _navigateToInquiryDetailScreen(Map<String, dynamic> inquiryData) {
    setState(() {
      _currentScreen = InquiryDetailScreen(
        inquiryData: inquiryData, // 서버에서 가져온 데이터 전달
        onNavigateBack: () {
          setState(() {
            _currentScreen = InquiryScreen(
              onNavigateBack: () {
                setState(() {
                  _currentScreen = HomeScreen(
                    onNavigateToInquiry: _navigateToInquiryScreen,
                    onNavigateToFAQ: _navigateToFAQScreen,
                    onNavigateToResult: _navigateToTextResultScreen,
                    onNavigateToMap: _navigateToMapScreen, // 추가
                  );
                });
              },
              onNavigateToInquiryCreate: _navigateToInquiryCreateScreen, // 문의 생성 화면으로 이동
              onNavigateToInquiryDetail: _navigateToInquiryDetailScreen, // 상세 페이지로 이동 콜백 전달
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
              onNavigateToMap: _navigateToMapScreen, // 추가
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
  void _navigateToResultScreen(File image, String wasteName, double accuracy, String imageUrl, String imgId, String userId, List<Map<String, dynamic>> wasteFees) {
    setState(() {
      _currentScreen = ResultScreen(
        image: image,
        wasteName: wasteName,
        accuracy: accuracy,
        imageUrl: imageUrl,
        imgId: imgId,
        userId: userId,
        wasteFees: wasteFees,  // wasteFees 전달
        onNavigateToSearch: _navigateToSearchScreen, // SearchScreen으로 이동하는 콜백 전달
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
            onNavigateToMap: _navigateToMapScreen, // 추가
          );
          break;
        case 1:
        // 검색 화면
          _currentScreen = SearchScreen(
            onNavigateToResult: _navigateToResultScreen,
          );
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
        title: Align(
          alignment: Alignment.bottomLeft,  // 왼쪽 아래 정렬
          child: Padding(
            padding: const EdgeInsets.only(left: 28, top: 33), // 10픽셀씩 오른쪽과 아래로 이동
            child: Image.asset(
              'assets/logo.png',
              height: 31,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5F5F5F)),
        toolbarHeight: 60, // 높이를 원하는 값으로 조정 (예: 80으로 설정)
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
