import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiService {
  static Future<Response> login(String email, String password) async {
    return await ApiConfig().postRequest('/login', data: {
      'email': email,
      'password': password,
    });
  }

  static Future<Response> getProfile() async {
    return await ApiConfig().getRequest('/profile');
  }

  // Add more API methods here as needed
  static Future<Response> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? bio,
    String? interests,
    required Map<String, String> address,
  }) async {
    return await ApiConfig().postRequest('/user/', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      if (bio != null) 'bio': bio,
      if (interests != null) 'interests': interests,
      'address': address,
    });
  }
} 