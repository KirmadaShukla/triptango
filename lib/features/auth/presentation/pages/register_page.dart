import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:triptango/shared/widgets/app_snackbar.dart';
import 'package:triptango/features/auth/presentation/providers/auth_provider.dart';
import 'package:triptango/core/constants/app_constants.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:triptango/core/models/address_model.dart';
import 'package:triptango/core/utils/network_utils.dart';
import 'dart:convert'; // Added for jsonDecode
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterScreenBody();
  }
}

class _RegisterScreenBody extends StatefulWidget {
  const _RegisterScreenBody({super.key});

  static const List<String> interestOptions = [
    'Hiking', 'Culture', 'Food', 'Adventure', 'Photography', 'Music', 'Nature', 'History'
  ];

  @override
  State<_RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<_RegisterScreenBody> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  int _currentStep = 0;

  @override
  void dispose() {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.clearRegistrationFields();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_currentStep < 2) _currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  void _submit() async {
    bool connected = await NetworkUtils.isConnected();
    print('Connected: $connected');
    if (!connected) {
      showAppSnackbar(context, 'No internet connection', SnackbarType.error);
      return;
    }
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final address = Address(
      addressLine1: provider.addressLine1Controller.text.trim(),
      addressLine2: provider.addressLine2Controller.text.trim().isEmpty
          ? null
          : provider.addressLine2Controller.text.trim(),
      country: provider.countryController.text.trim(),
      state: provider.stateController.text.trim(),
      city: provider.cityController.text.trim(),
      pincode: provider.pincodeController.text.trim(),
    );
    if (_formKey.currentState!.validate() && provider.selectedInterests.isNotEmpty) {
      final success = await provider.register(
        name: provider.nameController.text.trim(),
        email: provider.emailController.text.trim(),
        phone: provider.phoneController.text.trim(),
        password: provider.passwordController.text,
        bio: provider.bioController.text.trim().isNotEmpty ? provider.bioController.text.trim() : null,
        interest: provider.selectedInterests.join(','),
        address: address.toJson().map((k, v) => MapEntry(k, v ?? '')),
      );
      if (success) {
        showAppSnackbar(
          context,
          'Registration successful!',
          SnackbarType.success,
        );
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Lottie.asset(
              'assets/success_tick.json',
              repeat: false,
              onLoaded: (composition) async {
                await Future.delayed(composition.duration);
                Navigator.of(context).pop(); // Close dialog
                context.go('/home');
              },
            ),
          ),
        );
      } else {
        final error = provider.errorMessage ?? 'Registration failed';
        // If the error message is a JSON string, try to parse and show a user-friendly message
        String displayError = error;
        try {
          if (error.startsWith('{') && error.endsWith('}')) {
            final decoded = jsonDecode(error);
            if (decoded is Map && decoded['error'] != null) {
              displayError = decoded['error'].toString();
            }
          }
        } catch (_) {}
        showAppSnackbar(
          context,
          displayError,
          SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Lottie background animation
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Lottie.asset(
                  'assets/travel_the_world.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            // Foreground content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App icon as logo (circular with shadow)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/icon/app_icon.png'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFF2193b0),
                              Color(0xFF6dd5ed),
                              Color(0xFFf7971e),
                              Color(0xFFFF5858),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'TripTango',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                blurRadius: 12.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Step progress indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: StepProgressIndicator(
                          totalSteps: 3,
                          currentStep: _currentStep + 1,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          unselectedColor: Colors.grey[300]!,
                          size: 8,
                          roundedEdges: Radius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.85),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Consumer<AuthProvider>(
                            builder: (context, provider, _) {
                              if (provider.isLoading) {
                                return const Center(child: CircularProgressIndicator(color: Color(0xFF2193b0)));
                              }
                              return Form(
                                key: _formKey,
                                child: _buildFormStep(),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Color(0xFF2193b0),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Step navigation buttons at bottom left and right
            Positioned(
              left: 24,
              bottom: 32,
              child: _currentStep > 0
                  ? CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2193b0)),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _previousStep();
                        },
                        tooltip: 'Previous',
                      ),
                    )
                  : const SizedBox(width: 56),
            ),
            Positioned(
              right: 24,
              bottom: 32,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF2193b0),
                child: IconButton(
                  icon: Icon(
                    _currentStep == 2 ? Icons.check_rounded : Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (_currentStep == 2) {
                      _submit();
                    } else {
                      _nextStep();
                    }
                  },
                  tooltip: _currentStep == 2 ? 'Register' : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormStep() {
    final provider = Provider.of<AuthProvider>(context);
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            TextFormField(
              controller: provider.nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person, color: Color(0xFF2193b0)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2193b0), width: 2),
                ),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2193b0)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2193b0), width: 2),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter your email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            IntlPhoneField(
              controller: provider.phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone, color: Color(0xFF2193b0)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2193b0), width: 2),
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {},
              onSaved: (phone) {
                if (phone != null && phone.number.isNotEmpty) {
                  provider.phoneController.text = phone.completeNumber;
                } else {
                  provider.phoneController.clear();
                }
              },
              validator: (value) {
                if (value == null || value.number.isEmpty) return 'Enter your phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2193b0)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF2193b0),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2193b0), width: 2),
                ),
              ),
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter a password';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Your Address', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: provider.addressLine1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 1',
                        prefixIcon: Icon(Icons.home_outlined),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: AppConstants.textColor),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter address line 1' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: provider.addressLine2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 2 (optional)',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: AppConstants.textColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                   // Country, State, City Picker
                   CountryStateCityPicker(
                     country: provider.countryController,
                     state: provider.stateController,
                     city: provider.cityController,
                     dialogColor: Theme.of(context).colorScheme.background,
                     textFieldDecoration: InputDecoration(
                       fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                       filled: true,
                       suffixIcon: const Icon(Icons.arrow_downward_rounded),
                       border: const OutlineInputBorder(borderSide: BorderSide.none),
                       labelStyle: Theme.of(context).textTheme.bodyMedium,
                     ),
                   ),
                   const SizedBox(height: 8),
                    TextFormField(
                      controller: provider.pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        prefixIcon: Icon(Icons.pin_drop),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: AppConstants.textColor),
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter pincode';
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Your Interests', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                child: Text('Type your interest', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(24),
              child: TextField(
                controller: provider.interestsController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                  hintText: 'Search or add interest',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM, vertical: AppConstants.paddingS),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                onChanged: (_) {
                  setState(() {}); // To update filtered chips
                },
                onSubmitted: (value) {
                  final trimmed = value.trim();
                  if (trimmed.isNotEmpty && !provider.selectedInterests.contains(trimmed)) {
                    provider.addInterest(trimmed);
                  }
                  provider.interestsController.clear();
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _RegisterScreenBody.interestOptions
                    .where((option) => !provider.selectedInterests.contains(option))
                    .where((option) => provider.interestsController.text.isEmpty || option.toLowerCase().contains(provider.interestsController.text.toLowerCase()))
                    .map((option) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InputChip(
                            label: Text(option, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                            onPressed: () {
                              provider.addInterest(option);
                              setState(() {});
                            },
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                            elevation: 2,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      final trimmed = provider.interestsController.text.trim();
                      if (trimmed.isNotEmpty && !provider.selectedInterests.contains(trimmed)) {
                        provider.addInterest(trimmed);
                      }
                      provider.interestsController.clear();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: provider.selectedInterests
                    .map((interest) => InputChip(
                          label: Text(interest, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            provider.removeInterest(interest);
                            setState(() {});
                          },
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          elevation: 2,
                        ))
                    .toList(),
              ),
            ),
            if (provider.selectedInterests.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text('Enter your interests', style: TextStyle(color: AppConstants.errorColor)),
              ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
