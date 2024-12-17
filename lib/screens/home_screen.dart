import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
  // 기존 배너 이미지 목록
  final List<String> bannerImages = [
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png',
  ];

  final List<String?> bannerUrls = [
    null,
    'https://15990903.or.kr/portal/main/main.do',  // 두 번째 배너 이미지에 연결될 URL
    'https://www.koreagreen.org/',  // 세 번째 배너 이미지에 연결될 URL
    null
  ];

  late PageController _pageController;
  int currentPage = 0;

  String? homeMessage; // 홈 화면 데이터를 저장할 변수
  String searchQuery = "";  // text_result
  bool _isLoading = false; // 검색 로딩 상태

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9, // 배너 양옆 보이는 정도 줄이기 위해 값을 낮춤
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

  void _onBannerTap(int index) async {
    final url = bannerUrls[index];
    if (url != null) {
      // URL이 있을 경우에만 웹 브라우저에서 URL 열기
      print('배너 클릭됨: $url');
      // Uri 객체로 URL을 전달
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);  // launchUrl로 URL 열기
      } else {
        print("URL을 열 수 없습니다.");
      }
    } else {
      print('첫 번째 배너는 URL이 없습니다.');
    }
  }

  // 텍스트 검색 요청
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
      final Uri uri = Uri.parse('http://3.36.62.234:3000/lar-waste/search').replace(
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
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 15.0),
          child: Column(
            children: [
              // 홈 화면 데이터 출력
              if (homeMessage != null)
                Text(
                  homeMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF599468),
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 30),

              // 배너 슬라이더
              SizedBox(
                width: double.infinity,
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: bannerImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onBannerTap(index),  // 배너 클릭 시 URL로 이동
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            bannerImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 35),

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
                    onPressed: _searchWaste,
                  ),
                ],
              ),
              SizedBox(height: 35),

              // 지도 및 버튼들
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 지도 섹션
                  Flexible(
                    flex: 3,
                    child: GestureDetector(
                      onTap: widget.onNavigateToMap,
                      child: Container(
                        height: 250,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF599468), width: 1), // 테두리 굵기 1로 수정
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '우리 동네',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF599468),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                '스티커 판매점 찾기',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF5F5F5F),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF599468), width: 1), // 테두리 굵기 1로 수정
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          onTap: widget.onNavigateToFAQ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.help_outline, color: Color(0xFF599468), size: 45), // 물음표 아이콘으로 수정
                              SizedBox(height: 8),
                              Text(
                                '자주 묻는 질문',
                                style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      // 고객 문의 버튼
                      Container(
                        width: 130,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF599468), width: 1), // 테두리 굵기 1로 수정
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          onTap: widget.onNavigateToInquiry,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail_outline, color: Color(0xFF599468), size: 45), // 아이콘 크기 1.5배
                              SizedBox(height: 8),
                              Text(
                                '고객 문의',
                                style: TextStyle(
                                    color: Color(0xFF5F5F5F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
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
