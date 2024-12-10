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
  final String url = "http://10.0.2.2:3000/inquiry/view-all"; // 서버 URL

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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return ''; // 날짜가 없으면 빈 문자열 반환
    }
    try {
      // 서버에서 받은 문자열을 DateTime으로 변환
      DateTime parsedDate = DateTime.parse(dateStr);
      // 원하는 포맷으로 변환 (예: "2024년 12월 9일")
      return DateFormat('yyyy년 MM월 dd일').format(parsedDate);
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
    final String detailUrl = "http://10.0.2.2:3000/inquiry/view?inquiryId=$inquiryId";

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNavigateBack,
                  child: Image.asset(
                    'assets/backbutton.png',
                    height: 40,
                  ),
                ),
                Spacer(),
                Text(
                  '1:1 문의',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: widget.onNavigateToInquiryCreate, // InquiryCreateScreen으로 이동
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFFD9D9D9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(90, 42),
                  ),
                  child: Text(
                    '문의하기',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: <String>['전체']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 17),
                          ),
                        );
                      }).toList(),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: inquiries.isEmpty
                  ? Center(
                child: Text(
                  '문의 내역이 없습니다.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: inquiries.length,
                itemBuilder: (context, index) {
                  final inquiry = inquiries[index];
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white, // 배경 흰색
                                        border: Border.all(
                                            color: _getStatusColor(inquiry['res_status'])), // 상태 색상
                                        borderRadius: BorderRadius.circular(20.0), // 둥근 테두리
                                      ),
                                      child: Text(
                                        _getStatusText(inquiry['res_status']),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _getStatusColor(inquiry['res_status']), // 상태 색상
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Text(
                                  inquiry['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
