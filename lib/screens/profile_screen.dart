// 7. profile_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/screens/login_screen.dart';
import 'package:purix_academy/screens/class_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _subService = SubscriptionService();

  UserModel? _user;
  String _subInfo = 'FREE Member';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = await _authService.getCurrentUser();
    if (user != null && user.phone != null) {
      final info = await _subService.getSubscriptionInfo(user.phone!);
      if (mounted) {
        setState(() {
          _user = user;
          _subInfo = info;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('User data not found'))
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          _user!.getInitials(),
                          style: AppTheme.headingLarge.copyWith(color: AppTheme.backgroundColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user!.name ?? 'Student',
                      style: AppTheme.headingMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user!.phone ?? '',
                      style: AppTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Account Details', style: AppTheme.headingSmall),
                            const Divider(height: 24),
                            Text('Email: ${_user!.email ?? "N/A"}', style: AppTheme.bodyLarge),
                            const SizedBox(height: 8),
                            Text('Class: ${_user!.selectedClass ?? "N/A"}', style: AppTheme.bodyLarge),
                            const SizedBox(height: 8),
                            Text('Language: ${_user!.language ?? "ENG"}', style: AppTheme.bodyLarge),
                            const SizedBox(height: 8),
                            Text('Status: $_subInfo', style: AppTheme.bodyLarge.copyWith(color: AppTheme.primaryColor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ClassSelectionScreen()),
                        );
                      },
                      icon: const Icon(Icons.school),
                      label: const Text('Change Class'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await _authService.logoutUser();
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                      label: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorColor)),
                    ),
                  ],
                ),
    );
  }
}