import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }
    if (!_acceptTerms) {
      _showError('Please accept the terms and conditions');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signup(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
              top: 100,
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
            // Signup form aligned to bottom
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
                          // Full Name Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Full Name',
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
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: const Color(0xFFE5F3F6),
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
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: const Color(0xFFE5F3F6),
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
                                ),
                              ),
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
                                  filled: true,
                                  fillColor: const Color(0xFFE5F3F6),
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
                          // Confirm Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Confirm Password',
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
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: const Color(0xFFE5F3F6),
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
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF00707C),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Terms and Conditions Checkbox
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _acceptTerms = !_acceptTerms;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: ShapeDecoration(
                                    color: _acceptTerms
                                        ? const Color(0xFF00707C)
                                        : const Color(0xFFE5F3F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: _acceptTerms
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'I Agree to the ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Onest',
                                          fontWeight: FontWeight.w400,
                                          height: 1,
                                          letterSpacing: -0.40,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Terms and Conditions',
                                        style: TextStyle(
                                          color: Color(0xFF00707C),
                                          fontSize: 12,
                                          fontFamily: 'Onest',
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                          height: 1,
                                          letterSpacing: -0.40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Create Account Button and Login Icon Button Row
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Row(
                                children: [
                                  // Create Account Button
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: authProvider.isLoading
                                            ? null
                                            : _handleSignup,
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
                                                    'Create Account',
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
                                  // Login Button
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
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
                                          Icons.arrow_back,
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
