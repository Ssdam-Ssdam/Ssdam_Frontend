import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  final File image;
  final String wasteName;
  final double accuracy;
  final String imageUrl;
  final String imgId;

  ResultScreen({
    required this.image,
    required this.wasteName,
    required this.accuracy,
    required this.imageUrl,
    required this.imgId,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLike = false;
  bool _showAlternativeInput = false;
  bool _isButtonClicked = false;

  Future<void> _sendFeedback(int isGood) async {
    final String url = "http://10.0.2.2:3000/lar-waste/feedback";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'imgId': widget.imgId,
          'is_good': isGood.toString(),
        },
      );

      if (response.statusCode == 200) {
        _showAlert('피드백이 성공적으로 전송되었습니다.');
      } else {
        _showAlert('피드백 전송 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (error) {
      _showAlert('네트워크 오류: $error');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('결과: ${widget.wasteName}'),
            Text('정확도: ${widget.accuracy}%'),
            if (widget.imageUrl.isNotEmpty)
              Image.network(widget.imageUrl),
          ],
        ),
      ),
    );
  }
}
