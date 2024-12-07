import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secure_storage_util.dart';
import 'main_screen.dart';


//연결아직안함 텍스트 검색 후 결과화면
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'AI 분석 결과',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '결과 확인',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5F5F5F),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OO',
                        style:
                        TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                        '가로 50cm 이하, 세로 50cm 이하       1,000원'),
                    Text(
                        '가로 50cm 이하, 세로 100cm 이하      2,000원'),
                    Text(
                        '가로 90cm 이하, 세로 110cm 이하      3,000원'),
                    Text(
                        '가로 100cm 이하, 세로 150cm 이하     5,000원'),
                    Text(
                        '가로 100cm 이하, 세로 180cm 이하     7,000원'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ],
            )
        ),
      ),
    ),
  );
}

