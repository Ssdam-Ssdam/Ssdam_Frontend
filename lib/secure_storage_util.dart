import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static final _storage = FlutterSecureStorage();

  /// 토큰 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  /// 토큰 가져오기
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  /// 토큰 삭제
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
