import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.requestPasswordReset(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() {
        _emailSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email'),
          backgroundColor: Color(0xFF66BB6A),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to send reset link'),
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
            // Logo at top
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
            // Form aligned to bottom
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
                      child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
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

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reset Password',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 26,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your email address and we\'ll send you a link to reset your password',
            style: TextStyle(
              color: Color(0xFF88A8AF),
              fontSize: 14,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
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
              TextFormField(
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
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Reset button and Back button Row
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Row(
                children: [
                  // Reset Button
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: authProvider.isLoading ? null : _handleResetPassword,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF00707C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Send Reset Link',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Onest',
                                      fontWeight: FontWeight.w500,
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
                  // Back Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFC7EBEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: Color(0xFF66BB6A),
        ),
        const SizedBox(height: 24),
        const Text(
          'Email Sent!',
          style: TextStyle(
            color: Color(0xFF002E34),
            fontSize: 26,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
            height: 1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'We\'ve sent a password reset link to',
          style: TextStyle(
            color: Color(0xFF88A8AF),
            fontSize: 14,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text.trim(),
          style: const TextStyle(
            color: Color(0xFF00707C),
            fontSize: 16,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F3F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Next steps:',
                style: TextStyle(
                  color: Color(0xFF002E34),
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildStep('1. Check your email inbox'),
              const SizedBox(height: 8),
              _buildStep('2. Click the reset link'),
              const SizedBox(height: 8),
              _buildStep('3. Create a new password'),
              const SizedBox(height: 8),
              _buildStep('4. Sign in with your new password'),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: ShapeDecoration(
                color: const Color(0xFF00707C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: -0.70,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text(
            'Didn\'t receive the email? Resend',
            style: TextStyle(
              color: Color(0xFF00707C),
              fontSize: 14,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Color(0xFF66BB6A),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF002E34),
              fontSize: 14,
              fontFamily: 'Onest',
            ),
          ),
        ),
      ],
    );
  }
}
