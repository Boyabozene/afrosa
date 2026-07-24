import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> getHeaders({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint, {bool auth = false}) async {
    final headers = await getHeaders(auth: auth);
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body, {bool auth = false}) async {
    final headers = await getHeaders(auth: auth);
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<dynamic> patch(String endpoint, Map<String, dynamic> body, {bool auth = false}) async {
    final headers = await getHeaders(auth: auth);
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}