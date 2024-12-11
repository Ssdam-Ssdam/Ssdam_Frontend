import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToInquiry; // InquiryScreen으로 이동하는 콜백
  final VoidCallback onNavigateToFAQ; // FAQScreen으로 이동하는 콜백
  final Function(List<Map<String, dynamic>> wastes) onNavigateToResult; // 검색 결과 화면으로 이동하는 콜백
  final VoidCallback onNavigateToMap; // 추가: 지도 화면 이동 콜백

  HomeScreen({
    required this.onNavigateToInquiry,
    required this.onNavigateToFAQ,
    required this.onNavigateToResult, // 추가
    required this.onNavigateToMap, // 추가
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> bannerImages = [
    'assets/banner.png',
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
  ];

  late PageController _pageController;
  int currentPage = 0;

  String? homeMessage; // 홈 화면 데이터를 저장할 변수
  String searchQuery = "";  //text_result
  bool _isLoading = false; // 검색 로딩 상태



  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
    );

    // 자동 순환
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), _autoScroll);
    });
  }

  void _autoScroll() {
    if (_pageController.hasClients) {
      int nextPage = (currentPage + 1) % bannerImages.length;
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        currentPage = nextPage;
      });

      // 다시 호출
      Future.delayed(Duration(seconds: 3), _autoScroll);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // !!!!!!!!!텍스트 검색 요청
  Future<void> _searchWaste() async {
    if (searchQuery.isEmpty) {
      print("검색어를 입력해주세요.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 토큰 가져오기
      final token = await SecureStorageUtil.getToken();

      // URL에 검색어를 포함
      final Uri uri = Uri.parse('http://3.38.250.18:3000/lar-waste/search').replace(
        queryParameters: {
          'waste_name': searchQuery, // 검색어 추가
        },
      );

      // 서버 요청
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // 서버 응답 처리
        final responseBody = json.decode(response.body);
        final wastes = (responseBody['wastes'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        // 검색 결과 화면으로 이동
        widget.onNavigateToResult(wastes);
      } else {
        print("검색 실패: ${response.body}");
      }
    } catch (e) {
      print("네트워크 오류: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 홈 화면 데이터 출력
              if (homeMessage != null)
                Text(
                  homeMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF599468),
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),

              // 배너 슬라이더
              SizedBox(
                width: 350,
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: bannerImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          bannerImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // 검색 바
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          searchQuery = value; // 검색어 갱신
                        },
                        decoration: InputDecoration(
                          hintText: '폐기물 종류 검색',
                          hintStyle: TextStyle(color: Color(0xFF5F5F5F)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  _isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchWaste, // 검색 함수 호출
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 지도 및 버튼들
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 지도 섹션
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onNavigateToMap, // 지도 클릭 시 콜백 호출
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF599468)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '우리 동네',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF599468),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '폐기물 스티커 판매점 찾기',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF5F5F5F),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Image.asset(
                                'assets/map_placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      // 자주 묻는 질문 버튼
                      Container(
                        width: 130,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF599468)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: widget.onNavigateToFAQ, // FAQScreen 이동 콜백 호출
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.help_outline,
                                  color: Color(0xFF599468), size: 30),
                              SizedBox(height: 8),
                              Text(
                                '자주 묻는 질문',
                                style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // 고객 문의 버튼
                      Container(
                        width: 130,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF599468)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: widget.onNavigateToInquiry, // InquiryScreen 이동 콜백 호출
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline,
                                  color: Color(0xFF599468), size: 30),
                              SizedBox(height: 8),
                              Text(
                                '고객 문의',
                                style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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