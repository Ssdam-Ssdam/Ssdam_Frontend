import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // 오버플로우 방지를 위해 스크롤 가능하게 처리
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 배너 슬라이더
              SizedBox(
                width: 320,
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
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // 양 옆 여백 추가
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1), // 배경 색상 변경 (연한 초록색)
                        borderRadius: BorderRadius.circular(10), // 둥근 모서리
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '폐기물 종류 검색',
                          hintStyle: TextStyle(color: Colors.black26), // 힌트 텍스트 색상
                          border: InputBorder.none, // 기본 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.green),
                    onPressed: () {},
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
                    child: Container(
                      height: 250, // 길쭉한 크기로 설정
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '우리 동네',
                            style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '폐기물 스티커 판매점 찾기',
                            style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),
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
                  SizedBox(width: 30),
                  // 자주 묻는 질문 및 고객 문의 섹션
                  Column(
                    children: [
                      Container(
                        width: 130, // 버튼의 너비
                        height: 120, // 버튼의 높이
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.help_outline, color: Colors.green, size: 30),
                            SizedBox(height: 8),
                            Text(
                              '자주 묻는 질문',
                              style: TextStyle(color: Colors.green, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 130, // 버튼의 너비
                        height: 120, // 버튼의 높이
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline, color: Colors.green, size: 30),
                            SizedBox(height: 8),
                            Text(
                              '고객 문의',
                              style: TextStyle(color: Colors.green, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
