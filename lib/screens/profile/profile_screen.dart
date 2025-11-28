import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FB),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: const Color(0xFFEAF8FB),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF002E34),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xFF002E34),
                    fontSize: 26,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00707D),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      color: Color(0xFF002E34),
                      fontSize: 24,
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Color(0xFF88A8AF),
                      fontSize: 16,
                      fontFamily: 'Onest',
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Profile Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF8FDFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Information',
                          style: TextStyle(
                            color: Color(0xFF002E34),
                            fontSize: 18,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          Icons.person_outline,
                          'Name',
                          user?.name ?? 'N/A',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.email_outlined,
                          'Email',
                          user?.email ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF8FDFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/logo.svg',
                              width: 60,
                              height: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your personal health tracking companion',
                          style: TextStyle(
                            color: Color(0xFF88A8AF),
                            fontSize: 14,
                            fontFamily: 'Onest',
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Color(0xFF88A8AF),
                            fontSize: 12,
                            fontFamily: 'Onest',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleLogout(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2994A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF00707D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00707D),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF88A8AF),
                  fontSize: 14,
                  fontFamily: 'Onest',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF002E34),
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
