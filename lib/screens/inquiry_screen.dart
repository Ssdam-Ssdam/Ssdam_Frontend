import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart'; // SecureStorageUtil import
import 'package:intl/intl.dart'; // 날짜 포맷을 위한 intl 패키지

class InquiryScreen extends StatefulWidget {
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateToInquiryCreate; // InquiryCreateScreen으로 이동 콜백 추가
  final Function(Map<String, dynamic>) onNavigateToInquiryDetail;

  const InquiryScreen({
    super.key,
    required this.onNavigateBack,
    required this.onNavigateToInquiryCreate, // 콜백 초기화
    required this.onNavigateToInquiryDetail,
  });

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String selectedValue = '전체'; // 드롭다운 초기값
  List<Map<String, dynamic>> inquiries = []; // 문의 데이터 리스트
  List<Map<String, dynamic>> filteredInquiries = []; // 필터링된 문의 데이터 리스트
  final String url = "http://3.36.62.234:3000/inquiry/view-all"; // 서버 URL

  @override
  void initState() {
    super.initState();
    _fetchInquiries(); // 문의 데이터 로드
  }

  Future<void> _fetchInquiries() async {
    try {
      final token = await SecureStorageUtil.getToken();
      if (token == null) {
        print("토큰이 없습니다. 로그인이 필요합니다.");
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 'inquiry' 키의 데이터를 꺼내와서 리스트로 변환
        if (responseData.containsKey('inquiry')) {
          setState(() {
            inquiries = List<Map<String, dynamic>>.from(responseData['inquiry']);
            filteredInquiries = List.from(inquiries); // 초기에는 전체 데이터를 필터링된 데이터로 설정
          });
        } else {
          print("문의 데이터가 없습니다: ${response.body}");
        }
      } else {
        print("문의 데이터를 가져오지 못했습니다. 상태 코드: ${response.statusCode}");
      }
    } catch (error) {
      print("네트워크 오류: $error");
    }
  }

  void _filterInquiries() {
    setState(() {
      if (selectedValue == '전체') {
        filteredInquiries = List.from(inquiries); // 전체 선택 시 모든 문의 내역을 보여줌
      } else {
        filteredInquiries = inquiries.where((inquiry) {
          String statusText = _getStatusText(inquiry['res_status']);
          return statusText == selectedValue; // '진행중' 또는 '답변완료'에 맞게 필터링
        }).toList();
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return ''; // 날짜가 없으면 빈 문자열 반환
    }
    try {
      // 서버에서 받은 문자열을 DateTime으로 변환
      DateTime parsedDate = DateTime.parse(dateStr);
      // 원하는 포맷으로 변환 (예: "2024년 12월 9일")
      return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate); // 원하는 형식으로 포맷
    } catch (e) {
      print("날짜 포맷 오류: $e");
      return ''; // 변환 실패 시 빈 문자열 반환
    }
  }

  String _getStatusText(dynamic resStatus) {
    if (resStatus == null) return '알 수 없음'; // null 처리
    if (resStatus is bool) return resStatus ? '답변완료' : '진행중'; // bool 처리
    try {
      final int status = resStatus is int ? resStatus : int.parse(resStatus);
      return status == 0 ? '진행중' : '답변완료';
    } catch (e) {
      print('res_status 변환 오류: $e');
      return '알 수 없음';
    }
  }

  Color _getStatusColor(dynamic resStatus) {
    if (resStatus == null) return Colors.grey; // null 처리
    if (resStatus is bool) return resStatus ? Color(0xFF25A52D) : Color(0xFFCDB72A); // bool 처리
    try {
      final int status = resStatus is int ? resStatus : int.parse(resStatus);
      return status == 0 ? Color(0xFFCDB72A) : Color(0xFF25A52D);
    } catch (e) {
      print('res_status 변환 오류: $e');
      return Colors.grey;
    }
  }

  Future<Map<String, dynamic>?> _fetchInquiryDetail(int inquiryId) async {
    final String detailUrl = "http://3.36.62.234:3000/inquiry/view?inquiryId=$inquiryId";

    try {
      final token = await SecureStorageUtil.getToken();
      if (token == null) {
        print("토큰이 없습니다. 로그인이 필요합니다.");
        return null; // 토큰이 없으면 null 반환
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      print("Fetching details for inquiryId: $inquiryId");

      final response = await http.get(Uri.parse(detailUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("상세 데이터: $responseData");
        return responseData; // 서버에서 받은 데이터 반환
      } else {
        print("상세 데이터를 가져오지 못했습니다. 상태 코드: ${response.statusCode}");
        return null; // 실패 시 null 반환
      }
    } catch (error) {
      print("네트워크 오류: $error");
      return null; // 오류 발생 시 null 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색 설정
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16, top: 30), // 상단 여백 증가
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onNavigateBack,
                  child: Icon(
                    Icons.arrow_back, // 기본 안드로이드 뒤로가기 화살표 아이콘
                    color: Color(0xFF5F5F5F), // 색상 #5f5f5f 설정
                    size: 30, // 아이콘 크기 조정
                  ),
                ),
                Spacer(),  // 왼쪽 아이콘과 텍스트 사이에 공간을 추가
                Padding(
                  padding: const EdgeInsets.only(right: 32.0), // 왼쪽으로 10px 이동
                  child: Text(
                    '내 문의 내역',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                ),
                Spacer(),  // 텍스트 오른쪽에도 공간을 추가하여 화면 중앙에 정렬
              ],
            ),
          ),


          SizedBox(height: 15), // 상단과 문의하기 버튼 사이 간격 증가
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20.0), // 드롭다운 박스 둥글게 수정
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          _filterInquiries(); // 드롭다운 값이 변경될 때마다 필터링
                        });
                      },
                      items: <String>['전체', '진행중', '답변완료']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Expanded(
            child: filteredInquiries.isEmpty
                ? Center(
              child: Text(
                '문의 내역이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredInquiries.length,
              itemBuilder: (context, index) {
                final inquiry = filteredInquiries[index];
                return GestureDetector(
                  onTap: () async {
                    final inquiryId = inquiry['inquiryId'];
                    final responseData = await _fetchInquiryDetail(inquiryId); // 상세 데이터 가져오기

                    if (responseData != null) {
                      widget.onNavigateToInquiryDetail(responseData); // 상세 페이지로 이동
                    } else {
                      print("상세 데이터를 가져오는 데 실패했습니다.");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDate(inquiry['created_at']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFB6B6B6),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _getStatusColor(inquiry['res_status']),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getStatusText(inquiry['res_status']),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(inquiry['res_status']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  inquiry['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16), // 버튼과 리스트 간격을 더 여유 있게 설정
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백만 남김
            child: GestureDetector(
              onTap: widget.onNavigateToInquiryCreate, // 문의하기 화면으로 이동
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.0), // 버튼의 세로 길이에 맞게 여백 설정
                decoration: BoxDecoration(
                  color: Color(0xFF6EB681), // 배경색 설정
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '문의하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
