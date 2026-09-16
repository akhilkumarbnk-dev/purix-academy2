import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/class_selection_screen.dart';
import 'package:purix_academy/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _localStorageService = LocalStorageService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isExistingUser = false;

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  // Check if user already logged in
  Future<void> _checkExistingUser() async {
    final user = await _localStorageService.getUser();
    if (user != null && user.phone != null && user.phone!.isNotEmpty) {
      // User already logged in, go to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    }
  }

  // Handle login
  void _handleLogin() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.loginUser(phone: phone);

    if (result['success'] == true) {
      // User exists, go to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      // New user, show registration form
      setState(() => _isExistingUser = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New user detected. Please fill details.')),
      );
    }

    setState(() => _isLoading = false);
  }

  // Handle registration
  void _handleRegister() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name and phone are required')),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone must be 10 digits')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.registerUser(
      name: name,
      phone: phone,
      email: email,
      selectedClass: 'Class 8', // Default class
      language: 'ENG',
    );

    if (result['success'] == true) {
      // Registration successful, go to class selection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ClassSelectionScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'] ?? 'Registration failed')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                
                // Logo/Title
                Text(
                  'PURIX ACADEMY',
                  style: AppTheme.headingLarge.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'NEW WAY OF LEARNING',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),

                // Phone Input (Always visible)
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter 10-digit phone number',
                    prefixIcon: Icon(Icons.phone, color: AppTheme.primaryColor),
                  ),
                  enabled: !_isLoading,
                ),
                SizedBox(height: AppTheme.spacingM),

                // Conditional fields (show for new users)
                if (!_isExistingUser) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.person, color: AppTheme.primaryColor),
                    ),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: AppTheme.spacingM),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email (optional)',
                      prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
                    ),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: AppTheme.spacingM),
                ],

                // Login/Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_isExistingUser ? _handleLogin : _handleRegister),
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
                        : Text(_isExistingUser ? 'LOGIN' : 'GET STARTED'),
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Toggle button (if not loading)
                if (!_isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() => _isExistingUser = !_isExistingUser);
                    },
                    child: Text(
                      _isExistingUser
                          ? 'New user? Get started'
                          : 'Existing user? Login',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}