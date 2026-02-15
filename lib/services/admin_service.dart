import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AdminService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.OWNER_LOGIN),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
          await prefs.setBool('isAdmin', true);
        }
        return {'success': true};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<List<dynamic>> getUnverifiedAgents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(ApiConfig.UNVERIFIED_AGENTS),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['agents'] ?? [];
      }
      return [];
    } catch (e) {
      print('Fetch agents error: $e');
      return [];
    }
  }

  static Future<bool> verifyAgent(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return false;

      final response = await http.put(
        Uri.parse(ApiConfig.verifyAgent(id)),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Verify agent error: $e');
      return false;
    }
  }
}
