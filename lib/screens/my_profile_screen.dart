import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // 상단 여백
            // My Profile 제목
            Center(
              child: Text(
                'MY PROFILE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 프로필 섹션
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 프로필 이미지
                SizedBox(width: 20),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile.png'), // 프로필 이미지 경로
                    ),
                    SizedBox(height: 10),
                    Text(
                      'yukyoung',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(width: 20), // 이미지와 텍스트 간격
                // 이름과 위치
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'beloveuuu',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'My Location : 성남시 수정구',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            // 프로필 수정 및 분석 결과 조회 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('프로필 수정 클릭');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey),
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
                  onPressed: () {
                    print('분석 결과 조회 클릭');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey),
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
            Spacer(),
            // 로그아웃 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('로그아웃 클릭');
                    Navigator.pop(context); // 이전 화면으로 돌아가기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
