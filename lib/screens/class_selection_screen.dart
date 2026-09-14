// 2. class_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/screens/dashboard_screen.dart';

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  final _authService = AuthService();
  bool _isLoading = false;
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _loadCurrentClass();
  }

  Future<void> _loadCurrentClass() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _selectedClass = user.selectedClass ?? AppConfig.CLASSES.first;
      });
    }
  }

  Future<void> _updateClass() async {
    if (_selectedClass == null) return;

    setState(() {
      _isLoading = true;
    });

    final user = await _authService.getCurrentUser();
    if (user != null && user.phone != null) {
      final result = await _authService.updateUserClass(
        phone: user.phone!,
        newClass: _selectedClass!,
      );

      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        return;
      }
    }

    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update class')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your study level',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'You can change this anytime from your profile.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: AppConfig.CLASSES.length,
                itemBuilder: (context, index) {
                  final className = AppConfig.CLASSES[index];
                  final isSelected = _selectedClass == className;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          .toString()
                          .contains('true') // Selected styling
                          ? AppTheme.surfaceColor
                          : AppTheme.surfaceColor.withOpacity(0.5),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: ListTile(
                      title: Text(
                        className,
                        style: AppTheme.headingSmall,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedClass = className;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateClass,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}