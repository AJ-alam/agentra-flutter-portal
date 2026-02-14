import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/package.dart';
import 'auth_service.dart';

class PackageService {
  static Future<List<Package>> getAgentPackages() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(ApiConfig.AGENT_PACKAGES),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> packagesJson = data['packages'] ?? [];
        return packagesJson.map((json) => Package.fromJson(json)).toList();
      }
    } catch (e) {
      print('Get agent packages error: $e');
    }
    return [];
  }

  static Future<bool> createPackage({
    required String title,
    required String description,
    required String location,
    required double price,
    required String duration,
    required int availableSeats,
    String? image,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(ApiConfig.PACKAGES),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'location': location,
          'price': price,
          'duration': duration,
          'availableSeats': availableSeats,
          'image': image,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Create package error: $e');
      return false;
    }
  }

  static Future<bool> updatePackage(String id, Map<String, dynamic> updateData) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse(ApiConfig.packageDetail(id)),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(updateData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update package error: $e');
      return false;
    }
  }

  static Future<bool> deletePackage(String id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse(ApiConfig.packageDetail(id)),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete package error: $e');
      return false;
    }
  }
}
