import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FB),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo at top with absolute positioning
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  width: 100,
                  height: 40,
                ),
              ),
            ),
            // Login form aligned to bottom
            Column(
              children: [
                const Spacer(),
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF8FDFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: -0.70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder
                                      .none, // Removes default border
                                  filled:
                                      true, // Enable the background color fill
                                  fillColor: const Color(
                                      0xFFE5F3F6), // Background color
                                  contentPadding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 16,
                                    left: 10,
                                  ),
                                  // Added the borderRadius here
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: -0.70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled:
                                      true, // Enable the background color fill
                                  fillColor: const Color(
                                      0xFFE5F3F6), // Background color
                                  contentPadding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 16,
                                    left: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF00707C),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Remember Me & Forgot Password Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember Me Checkbox
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: ShapeDecoration(
                                        color: _rememberMe
                                            ? const Color(0xFF00707C)
                                            : const Color(0xFFE5F3F6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: _rememberMe
                                          ? const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Onest',
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                        letterSpacing: -0.40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Forgot Password Link
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Login Button and Sign Up Icon Button Row
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Row(
                                children: [
                                  // Login Button
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: authProvider.isLoading
                                            ? null
                                            : _handleLogin,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          height: 50,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFF00707C),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: authProvider.isLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Continue Auth',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontFamily: 'Onest',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                      letterSpacing: -0.70,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Sign Up Button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen(),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFC7EBEF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_add,
                                          color: Color(0xFF00707C),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
