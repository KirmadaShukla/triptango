import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiService {
  static Future<Response> login(String email, String password) async {
    try {
      return await ApiConfig().postRequest('/user/jwt/login/', data: {
        'email': email, // Use 'email' as required by backend JWT
        'password': password,
      });
    } catch (e) {
      if (e is DioError) {
        print('Error data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      } else {
        print(e);
      }
      rethrow;
    }
  }

  static Future<Response> getProfile() async {
    return await ApiConfig().getRequest('/profile');
  }

  static Future<Response> googleLogin(String idToken) async {
    try {
      return await ApiConfig().postRequest('/user/google-login/', data: {
        'id_token': idToken,
      });
    } catch (e) {
      if (e is DioError) {
        print('Error data:  [${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      } else {
        print(e);
      }
      rethrow;
    }
  }

  // Add more API methods here as needed
  static Future<Response> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? bio,
    String? interest,
    required Map<String, String> address,
  }) async {
    return await ApiConfig().postRequest('/user/', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      if (bio != null) 'bio': bio,
      if (interest != null) 'interest': interest,
      'address': address,
    });
  }
} 