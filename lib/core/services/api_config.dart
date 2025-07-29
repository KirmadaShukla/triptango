import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;

  late final Dio dio;

  ApiConfig._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.140.123.43:8000/api', // Use machine IP for real device
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    // You can add interceptors here if needed
  }

  Future<void> setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Centralized generic HTTP methods
  Future<Response> getRequest(String path, {Map<String, dynamic>? queryParameters}) async {
    await setAuthHeader();
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> postRequest(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    await setAuthHeader();
    print('[DEBUG] Making POST request to: ${dio.options.baseUrl}$path');
    print('[DEBUG] Request data: $data');
    print('[DEBUG] Request headers: ${dio.options.headers}');
    
    final response = await dio.post(path, data: data, queryParameters: queryParameters);
    
    print('[DEBUG] Response status: ${response.statusCode}');
    print('[DEBUG] Response data: ${response.data}');
    
    return response;
  }

  Future<Response> putRequest(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    await setAuthHeader();
    return await dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> deleteRequest(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    await setAuthHeader();
    return await dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
