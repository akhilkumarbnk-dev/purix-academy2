import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/screens/class_selection_screen.dart';
import 'package:purix_academy/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _localStorageService = LocalStorageService();
  final _subscriptionService = SubscriptionService();
  final _authService = AuthService();

  UserModel? _user;
  bool _isPro = false;
  int _remainingDays = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _localStorageService.getUser();
    final isPro = await _subscriptionService.isPro(user?.phone ?? '');
    final remainingDays =
        await _subscriptionService.getRemainingDays(user?.phone ?? '');

    setState(() {
      _user = user;
      _isPro = isPro;
      _remainingDays = remainingDays;
      _isLoading = false;
    });
  }

  void _changeClass() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ClassSelectionScreen()),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.logoutUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                            ),
                            child: Center(
                              child: Text(
                                _user?.getInitials() ?? '?',
                                style: AppTheme.headingMedium.copyWith(
                                  color: AppTheme.backgroundColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppTheme.spacingL),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user?.name ?? 'User',
                                  style: AppTheme.headingSmall,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _user?.phone ?? '',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // User Details
                Text(
                  'DETAILS',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Email
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _user?.email ?? 'N/A',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Class
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Class',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _user?.selectedClass ?? 'Class 8',
                            style: AppTheme.bodyMedium,
                          ),
                          Icon(Icons.edit, color: AppTheme.primaryColor, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Language
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language Preference',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _user?.language == 'HIN' ? 'हिंदी (Hindi)' : 'English',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // Subscription Info
                Text(
                  'SUBSCRIPTION',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isPro ? AppTheme.tertiaryColor : AppTheme.borderColor,
                      width: _isPro ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isPro ? 'PRO MEMBER' : 'FREE MEMBER',
                            style: AppTheme.bodyLarge.copyWith(
                              color:
                                  _isPro ? AppTheme.tertiaryColor : AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _isPro ? AppTheme.tertiaryColor : AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _isPro ? 'ACTIVE' : 'INACTIVE',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if (_isPro)
                        Text(
                          'Remaining Days: $_remainingDays days',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.tertiaryColor,
                          ),
                        )
                      else
                        Text(
                          'Upgrade to PRO for unlimited access',
                          style: AppTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _changeClass,
                    icon: Icon(Icons.swap_horiz),
                    label: Text('CHANGE CLASS'),
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: Icon(Icons.logout),
                    label: Text('LOGOUT'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}