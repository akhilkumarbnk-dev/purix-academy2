// 4. dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/screens/subject_screen.dart';
import 'package:purix_academy/screens/free_section_screen.dart';
import 'package:purix_academy/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final _authService = AuthService();
  final _subService = SubscriptionService();

  UserModel? _user;
  bool _isPro = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    if (user != null && user.phone != null) {
      final isPro = await _subService.isPro(user.phone!);
      if (mounted) {
        setState(() {
          _user = user;
          _isPro = isPro;
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
    final List<Widget> screens = [
      SubjectScreen(className: _user?.selectedClass ?? 'Class 10'),
      const FreeSectionScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Free Zone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}