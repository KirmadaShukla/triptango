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
  bool _isLoginLoading = false;
  bool _isGoogleLoading = false;

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
  bool get isLoginLoading => _isLoginLoading;
  bool get isGoogleLoading => _isGoogleLoading;

  Future<void> login(String email, String password) async {
    _isLoginLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.login(email, password);
      if (response.statusCode == 200 && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await fetchUserProfile();
      } else {
        _errorMessage = response.data['error'] ?? 'Login failed';
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['error'] ?? 'Network error';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoginLoading = false;
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
    _isGoogleLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId: '1025954988698-l7pj6dqd6h5su5k0k1h7o94k4kic6rsh.apps.googleusercontent.com', // <-- Replace with your actual Web client ID
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted by user');
        _errorMessage = 'Google sign-in aborted';
        _isGoogleLoading = false;
        notifyListeners();
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Google User ID:  [${googleUser.id}');
      print('Google User Name:  [${googleUser.displayName}');
      print('Google User Email:  [${googleUser.email}');
      print('Google ID Token:  [${googleAuth.idToken}');
      print('Google Access Token:  [${googleAuth.accessToken}');
      if (googleAuth.idToken == null) {
        print('Google idToken is null!');
        _errorMessage = 'Google sign-in failed: No idToken';
        _isGoogleLoading = false;
        notifyListeners();
        return;
      }
      final response = await ApiService.googleLogin(googleAuth.idToken!);
      print('Google login backend response:  [${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        _user = UserModel(
          id: googleUser.id,
          name: response.data['name'] ?? googleUser.displayName ?? 'Google User',
          email: response.data['email'] ?? googleUser.email,
          phone: '',
        );
        _errorMessage = null;
      } else {
        _errorMessage = response.data['error'] ?? 'Google login failed';
      }
    } catch (e, stack) {
      print('Google sign-in error: $e');
      print('Stack trace: $stack');
      _errorMessage = 'Google sign-in failed';
    } finally {
      _isGoogleLoading = false;
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
    String? interest,
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
        interest: interest,
        address: address,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Optionally fetch user profile or set _user here
        return true;
      } else {
        _errorMessage = response.data['error'] ?? 'Registration failed';
        return false;
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['error'] ?? 'Network error';
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