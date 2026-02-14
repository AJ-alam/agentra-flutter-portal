import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/agent.dart';

class AuthService {
  static String? _token;
  static Agent? _currentAgent;

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String businessName,
    required String email,
    required String phone,
    required String cnic,
    required String password,
    String? licenseNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.AGENT_REGISTER),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'businessName': businessName,
          'email': email,
          'phone': phone,
          'cnic': cnic,
          'password': password,
          'licenseNumber': licenseNumber,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = data['token'];
        if (_token != null) {
          await _saveToken(_token!);
          return {'success': true};
        }
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed'
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.AGENT_LOGIN),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['token'];
        if (_token != null) {
          await _saveToken(_token!);
          // Load agent profile after login
          await getCurrentAgent();
          return {'success': true};
        }
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Login failed'
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<void> logout() async {
    _token = null;
    _currentAgent = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  static Future<Agent?> getCurrentAgent() async {
    if (_currentAgent != null) return _currentAgent;
    
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.AGENT_PROFILE),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentAgent = Agent.fromJson(data['agent']);
        return _currentAgent;
      }
    } catch (e) {
      print('Get agent error: $e');
    }
    return null;
  }

  static bool isLoggedIn() {
    return _token != null;
  }
}
