import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:daum_postcode_search/daum_postcode_search.dart'; // 주소_추가

import 'login_screen.dart'; // LoginScreen 경로를 맞추세요

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  bool _isError = false;
  String? errorMessage;

  final TextEditingController _userIdController = TextEditingController(); // 아이디 컨트롤러
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 컨트롤러
  final TextEditingController _confirmPasswordController = TextEditingController(); // 비밀번호 확인 컨트롤러
  final TextEditingController _nameController = TextEditingController(); // 이름 컨트롤러
  final TextEditingController _emailController = TextEditingController(); // 이메일 컨트롤러
  final TextEditingController _addressController = TextEditingController(); // 주소 컨트롤러
  final TextEditingController _regionController = TextEditingController(); // 주소 컨트롤러-시도
  final TextEditingController _subRegionController = TextEditingController(); // 주소 컨트롤러-시군구
  final TextEditingController _streetController = TextEditingController(); // 주소 컨트롤러-도로명값
  final TextEditingController _zonecodeController = TextEditingController(); // 주소 컨트롤러-우편번호

  Future<void> _register(BuildContext context) async {
    final String url = "http://3.36.62.234:3000/user/register"; // Node.js 서버 URL
    final String userId = _userIdController.text.trim(); // 아이디 입력값 가져오기
    final String password = _passwordController.text.trim(); // 비밀번호 입력값 가져오기
    final String confirmPassword = _confirmPasswordController.text.trim(); // 비밀번호 확인
    final String name = _nameController.text.trim(); // 이름 입력값 가져오기
    final String email = _emailController.text.trim(); // 이메일 입력값 가져오기
    final String address = _addressController.text.trim(); // 주소 입력값 가져오기
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

    if (password != confirmPassword) {
      // 비밀번호와 비밀번호 확인이 일치하지 않을 경우 알림창 표시
      _showErrorDialog(context, "비밀번호가 일치하지 않습니다.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "password": password,
          "name": name,
          "email": email,
          "full_address": address,
          "region": region,
          "sub_region": sub_region,
          "street": street,
          "zonecode": zonecode,
        }),
      );

      if (response.statusCode == 200) {
        // 회원가입 성공 시 로그인 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        // 서버 응답에 따른 실패 처리
        final responseBody = json.decode(response.body);
        _showErrorDialog(context, responseBody['message'] ?? "회원가입에 실패했습니다.");
      }
    } catch (error) {
      // 네트워크 오류 처리
      _showErrorDialog(context, "네트워크 오류가 발생했습니다.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("회원가입 실패"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) {
        print("Console Message: $message");
      },
      onReceivedError: (controller, request, error) {
        setState(() {
          _isError = true;
          errorMessage = error.description;
        });
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 나타날 때 화면 크기 조정
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // 양옆 여백 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40), // 상단 여백 추가
              // 앱 로고 및 타이틀
              Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // 아이디 입력 필드
              TextField(
                controller: _userIdController,
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

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
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

              // 비밀번호 확인 입력 필드
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              SizedBox(height: 20),

              // 이름 입력 필드
              TextField(
                controller: _nameController,
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

              // 이메일 입력 필드
              TextField(
                controller: _emailController,
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

              Visibility(
                visible: _isError,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(errorMessage ?? ""),
                    ElevatedButton(
                      child: Text("새로고침"),
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

                        // 주소 검색 화면에서 반환된 값이 null이 아닐 때 처리
                        if (result != null) {
                          setState(() {
                            _addressController.text = result['address']; // 선택된 주소
                            _isError = false;  // 오류 상태 리셋
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Visibility(
              //   visible: _isError,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Text(errorMessage ?? ""),
              //       ElevatedButton(
              //         child: Text("새로고침"),
              //         onPressed: () async {
              //           // 주소 검색 화면 띄우기
              //           final result = await Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => DaumPostcodeSearch(),
              //             ),
              //           );
              //           // 주소 선택 후 반환된 값을 텍스트 필드에 표시
              //           if (result != null) {
              //             _addressController.text = result;
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              // 가입 버튼
              ElevatedButton(
                onPressed: () => _register(context), // 가입 버튼 클릭 시 API 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF599468),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  '가입',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}