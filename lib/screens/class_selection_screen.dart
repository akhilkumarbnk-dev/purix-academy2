import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/dashboard_screen.dart';

class ClassSelectionScreen extends StatefulWidget {
  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  final _authService = AuthService();
  final _localStorageService = LocalStorageService();
  String? _selectedClass;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedClass();
  }

  Future<void> _loadSelectedClass() async {
    final user = await _localStorageService.getUser();
    setState(() {
      _selectedClass = user?.selectedClass ?? 'Class 8';
    });
  }

  Future<void> _handleClassSelection(String selectedClass) async {
    setState(() => _isLoading = true);

    final user = await _localStorageService.getUser();
    if (user != null) {
      final result = await _authService.updateUserClass(
        phone: user.phone!,
        newClass: selectedClass,
      );

      if (result['success'] == true) {
        setState(() => _selectedClass = selectedClass);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update class')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppTheme.backgroundColor),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Text(
                  'SELECT YOUR CLASS',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Select your standard to personalize your learning dashboard.',
                  style: AppTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),

                // Class Cards
                ...AppConfig.CLASSES.map((className) {
                  bool isSelected = _selectedClass == className;
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLarge),
                          color: isSelected
                              ? AppTheme.surfaceColor.withOpacity(0.5)
                              : AppTheme.surfaceColor,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading
                                ? null
                                : () => _handleClassSelection(className),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusLarge),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingL,
                                vertical: AppTheme.spacingM,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        className,
                                        style: AppTheme.headingSmall.copyWith(
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _getClassDescription(className),
                                        style: AppTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppTheme.primaryColor,
                                      size: 28,
                                    )
                                  else
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppTheme.textSecondaryColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingM),
                    ],
                  );
                }).toList(),

                SizedBox(height: 30),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _handleClassSelection(_selectedClass!),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppTheme.backgroundColor,
                              ),
                            ),
                          )
                        : Text('CONTINUE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getClassDescription(String className) {
    switch (className) {
      case 'Class 8':
        return 'Foundation, Concepts & Practice';
      case 'Class 9':
        return 'Pre-Board Core Concepts & Notes';
      case 'Class 10':
        return 'Board Exam Mastery, High-Yield Qs';
      case 'Board Special':
        return 'Target Crash Course, Formulas & Mock Tests';
      default:
        return '';
    }
  }
}