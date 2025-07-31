import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_config.dart';
import '../models/trip_model.dart';

class ApiService {
  static Future<Response> login(String email, String password) async {
    try {
      final data = {
        'email': email,
        'password': password,
      };
      print('[DEBUG] Sending login request with data: $data');
      
      final response = await ApiConfig().postRequest(
        '/user/jwt/login/',
        data: data,
      );
      
      print('[DEBUG] Login response status: ${response.statusCode}');
      print('[DEBUG] Login response data: ${response.data}');
      
      return response;
    } catch (e) {
      if (e is DioError) {
        print('[ERROR] Login failed - Status: ${e.response?.statusCode}');
        print('[ERROR] Login failed - Data: ${e.response?.data}');
        print('[ERROR] Login failed - Headers: ${e.response?.headers}');
      } else {
        print('[ERROR] Login failed with exception: $e');
      }
      rethrow;
    }
  }

  static Future<Response> getProfile() async {
    return await ApiConfig().getRequest('/user/profile');
  }

  static Future<Response> googleLogin(String idToken) async {
    try {
      return await ApiConfig().postRequest(
        '/user/google-login/',
        data: {'id_token': idToken},
      );
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
  static Future<Response> getFeaturedTrips() async {
    try {
      return await ApiConfig().getRequest('/trip/featured/');
    } catch (e) {
      debugPrint('Error occured $e');
      rethrow;
    }
  }

  static Future<Response> getUpcomingTrips() async {
    try {
      return await ApiConfig().getRequest('/trip/upcoming/');
    } catch (e) {
      debugPrint('Error occured $e');
      rethrow;
    }
  }

  static Future<Response> getRecommendedTrips() async {
    try {
      return await ApiConfig().getRequest('/trip/recommend/');
    } catch (e) {
      debugPrint('Error occured $e');
      rethrow;
    }
  }

  static Future<Response> getTrendingDestinations() async {
    try {
      return await ApiConfig().getRequest('/trip/trending-destinations/');
    } catch (e) {
      debugPrint('Error occured $e');
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
    return await ApiConfig().postRequest(
      '/user/',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        if (bio != null) 'bio': bio,
        if (interest != null) 'interest': interest,
        'address': address,
      },
    );
  }
}
