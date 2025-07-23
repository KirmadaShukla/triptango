import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/features/auth/presentation/providers/auth_provider.dart';
import 'package:triptango/shared/widgets/app_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:triptango/features/auth/presentation/pages/register_page.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginScreenBody();
  }
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
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
                              Color(0xFF2193b0), // blue
                              Color(0xFF6dd5ed), // light blue
                              Color(0xFFf7971e), // orange
                              Color(0xFFFF5858), // red
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
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFF6dd5ed), // light blue
                              Color(0xFFf7971e), // orange
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'Travel with Strangers, Make New Friends',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.1,
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Colors.black38,
                                offset: Offset(1.5, 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.92),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: const _LoginForm(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2193b0)),
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
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2193b0)),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF2193b0),
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
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigate to password reset page
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Color(0xFF2193b0), fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 24),
        provider.isLoginLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2193b0)))
            : ElevatedButton(
                onPressed: () async {
                  await provider.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (provider.user != null) {
                    showAppSnackbar(context, 'Login successful!', SnackbarType.success);
                    context.go('/home');
                  } else if (provider.errorMessage != null) {
                    showAppSnackbar(context, provider.errorMessage!, SnackbarType.error);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2193b0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 5,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
        const SizedBox(height: 16),
        // Divider with 'or'
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('or', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 16),
        provider.isGoogleLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2193b0)))
            : ElevatedButton.icon(
                icon: Image.asset(
                  'assets/icon/google_icon.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () async {
                  await provider.signInWithGoogle();
                  if (provider.user != null) {
                    showAppSnackbar(context, 'Google login successful!', SnackbarType.success);
                    context.go('/home');
                  } else if (provider.errorMessage != null) {
                    showAppSnackbar(context, provider.errorMessage!, SnackbarType.error);
                  }
                },
              ),
        // Sign up option at bottom right
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 8, right: 0, left: 0, bottom: 0),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Don’t have an account? Sign Up',
              style: TextStyle(
                color: Color(0xFF2193b0),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF2193b0)))
        : ElevatedButton.icon(
            icon: Image.asset(
              'assets/icon/google_icon.png', // Use a Google icon asset
              height: 24,
              width: 24,
            ),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: () async {
              await provider.signInWithGoogle();
              if (provider.user != null) {
                showAppSnackbar(context, 'Google login successful!', SnackbarType.success);
                context.go('/home');
              } else if (provider.errorMessage != null) {
                showAppSnackbar(context, provider.errorMessage!, SnackbarType.error);
              }
            },
          );
  }
}
