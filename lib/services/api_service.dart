import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Android emulator

  // تسجيل الدخول
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var error =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw Exception(error['detail'] ?? 'فشل تسجيل الدخول');
    }
  }

  // تسجيل مستخدم جديد (مع phone)
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,      // ✅ مهم
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var error =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw Exception(error['detail'] ?? 'فشل التسجيل');
    }
  }
}
