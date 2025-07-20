import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  // Registration controllers and state
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final List<String> selectedInterests = [];

  void addInterest(String interest) {
    if (!selectedInterests.contains(interest)) {
      selectedInterests.add(interest);
      notifyListeners();
    }
  }

  void removeInterest(String interest) {
    selectedInterests.remove(interest);
    notifyListeners();
  }

  void clearRegistrationFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    bioController.clear();
    interestsController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    countryController.clear();
    stateController.clear();
    cityController.clear();
    pincodeController.clear();
    selectedInterests.clear();
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.login(email, password);
      if (response.statusCode == 200 && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await fetchUserProfile();
      } else {
        _errorMessage = response.data['message'] ?? 'Login failed';
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Network error';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.getProfile();
      if (response.statusCode == 200 && response.data != null) {
        _user = UserModel.fromJson(response.data);
      } else {
        _errorMessage = response.data['message'] ?? 'Failed to load profile';
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Network error';
    } catch (e) {
      _errorMessage = 'Failed to load profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _user = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _errorMessage = 'Google sign-in aborted';
        _isLoading = false;
        notifyListeners();
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Here you would send googleAuth.idToken or googleAuth.accessToken to your backend for verification and login/registration
      // For demo, we'll just create a dummy user
      _user = UserModel(
        id: googleUser.id,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        phone: '', // Google sign-in does not provide phone, so use empty string or prompt user later
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Google sign-in failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? bio,
    String? interests,
    required Map<String, String> address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        bio: bio,
        interests: interests,
        address: address,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Optionally fetch user profile or set _user here
        return true;
      } else {
        _errorMessage = response.data['message'] ?? 'Registration failed';
        return false;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Network error';
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 