import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;

  late final Dio dio;

  ApiConfig._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:8000/api', // Use dotenv if needed
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
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
    return await dio.post(path, data: data, queryParameters: queryParameters);
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