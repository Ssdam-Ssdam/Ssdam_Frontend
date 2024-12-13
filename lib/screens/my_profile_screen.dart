import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';
import 'login_screen.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart'; // 주소_추가

class MyProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateToHistory;

  const MyProfileScreen({super.key, required this.onNavigateToHistory});


  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool isEditing = false; // 현재 프로필 수정 화면인지 여부
  bool _isError = false;
  String? errorMessage;

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sim_addressController = TextEditingController();
  final TextEditingController _regionController = TextEditingController(); // 주소 컨트롤러-시도
  final TextEditingController _subRegionController = TextEditingController(); // 주소 컨트롤러-시군구
  final TextEditingController _streetController = TextEditingController(); // 주소 컨트롤러-도로명값
  final TextEditingController _zonecodeController = TextEditingController(); // 주소 컨트롤러-우편번호

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // 프로필 정보 로드
  }

  // 프로필 정보 조회 (GET 요청)
  Future<void> _fetchProfile() async {
    final String url = "http://3.38.250.18:3000/user/profile"; // Node.js 서버 URL

    try {
      final token = await SecureStorageUtil.getToken(); // 저장된 토큰 가져오기

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // 토큰 추가
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // 사용자 정보 UI에 반영
        setState(() {
          //userId, password, name, email, address(전체주소), sim_address(시,구)
          _userIdController.text = responseBody['userId'];
          _nameController.text = responseBody['name'];
          _addressController.text = responseBody['address'];
          _sim_addressController.text = responseBody['sim_address'];
          _passwordController.text = responseBody['password'];
          _emailController.text = responseBody['email'];
        });
      } else {
        print("프로필 정보를 가져오지 못했습니다. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }


// 프로필 정보 수정 (PUT 요청)
  Future<void> _updateProfile() async {
    final String url = "http://3.38.250.18:3000/user/profile/update"; // Node.js 서버 URL

    final String userId = _userIdController.text;
    final String password = _passwordController.text;
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String address = _addressController.text;
    final String region = _regionController.text.trim(); // 주소 입력값 가져오기
    final String sub_region = _subRegionController.text.trim(); // 주소 입력값 가져오기
    final String street = _streetController.text.trim(); // 주소 입력값 가져오기
    final String zonecodeStr = _zonecodeController.text.trim(); // 주소 입력값 가져오기
    // final zonecode = int.parse(zonecodeStr); // 정수로 변환

    int zonecode = 0;  // 기본값 설정
    try {
      zonecode = int.parse(zonecodeStr); // 정수로 변환
    } catch (e) {
      print("Zonecode 변환 오류: $e");
    }

    try {
      final token = await SecureStorageUtil.getToken(); // 저장된 토큰 가져오기

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // 토큰 추가
          "Content-Type": "application/json"
        },
        body: json.encode({
          "userId": userId,
          "password": password,
          "name": name,
          "email": email,
          "region": region,
          "sub_region": sub_region,
          "street": street,
          "full_address": address,
          "zonecode": zonecode,
        }),
      );

      if (response.statusCode == 200) {
        print("프로필 정보가 성공적으로 업데이트되었습니다.");
        setState(() {
          isEditing = false; // 수정 화면에서 프로필 화면으로 전환
        });
        _fetchProfile(); // 업데이트 후 프로필 정보 다시 로드
      } else {
        print("프로필 수정 실패. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }

  // 프로필 화면 위젯
  Widget buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = true; // 수정 화면으로 전환
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFD9D9D9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '프로필 수정',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: widget.onNavigateToHistory, // 콜백 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFFD9D9D9)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '분석 결과 조회',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // 수정 화면 위젯
  Widget buildEditProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(
            'EDIT PROFILE',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _userIdController, // userId 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController, // password 컨트롤러 연결
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _nameController, // name 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _emailController, // email 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '이메일',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),

              // 주소 입력 필드 + 검색 버튼
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: '주소',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {

                      // 주소 검색 화면 띄우기
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaumPostcodeSearch(
                            onConsoleMessage: (_, message) {
                              print("Console Message: $message");
                            },
                            onReceivedError: (controller, request, error) {
                              setState(() {
                                _isError = true;
                                errorMessage = error.description;
                              });
                            },
                          ),
                        ),
                      );

                      // 반환된 데이터가 DataModel 객체인지 확인하고 사용
                      if (result is DataModel) {
                        setState(() {
                          // 주소 및 추가 정보를 각 컨트롤러에 설정
                          _addressController.text = result.address;
                          _regionController.text = result.sido;
                          _subRegionController.text = result.sigungu;
                          _streetController.text = result.roadname;
                          _zonecodeController.text = result.zonecode;
                        });
                      } else {
                        print("Invalid data type returned: $result");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[350],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(60, 50),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF599468),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _updateProfile, // 프로필 수정 버튼 클릭 시 API 호출
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(120, 40),
              ),
              child: Text(
                '수정하기',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 항상 표시되는 공통 헤더
                    Center(
                      child: Text(
                        'MY PROFILE',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _nameController.text, // name 표시
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userIdController.text, // userId 표시
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'My Location : ${_sim_addressController.text}', // address 표시
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    isEditing ? buildEditProfileView() : buildProfileView(),
                  ],
                ),
              ),
            ),
          ),
          // 로그아웃 버튼은 프로필 화면에서만 표시
          if (!isEditing)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // 저장된 토큰 삭제
                      await SecureStorageUtil.deleteToken();

                      // 로그인 화면으로 이동하면서 이전 화면 스택 제거
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(), // LoginScreen을 여기에 넣어주세요
                        ),
                            (Route<dynamic> route) => false, // 이전 모든 화면 제거
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFFD9D9D9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(120, 40),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                ],
              ),
            ),
        ],
      ),
    );
  }
}
