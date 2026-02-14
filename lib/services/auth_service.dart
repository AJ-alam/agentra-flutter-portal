import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/agent.dart';

class AuthService {
  static String? _token;
  static Agent? _currentAgent;

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
        _currentAgent = Agent.fromJson(data['agent']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('agent', jsonEncode(data['agent']));
        
        return {'success': true, 'agent': _currentAgent};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }

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

      if (response.statusCode == 201) {
        _token = data['token'];
        _currentAgent = Agent.fromJson(data['agent']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('agent', jsonEncode(data['agent']));

        return {'success': true, 'agent': _currentAgent};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }

  static Future<void> logout() async {
    _token = null;
    _currentAgent = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Agent?> getCurrentAgent() async {
    if (_currentAgent != null) return _currentAgent;
    
    final prefs = await SharedPreferences.getInstance();
    final agentStr = prefs.getString('agent');
    if (agentStr != null) {
      _currentAgent = Agent.fromJson(jsonDecode(agentStr));
      _token = prefs.getString('token');
      return _currentAgent;
    }
    return null;
  }

  static String? get token => _token;
}
