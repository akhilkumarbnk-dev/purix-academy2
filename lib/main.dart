import 'package:flutter/material.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/login_screen.dart';
import 'package:purix_academy/screens/dashboard_screen.dart';
import 'package:purix_academy/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage service
  final localStorageService = LocalStorageService();
  await localStorageService.initialize();

  // Check existing login status from local storage
  UserModel? user = await localStorageService.getUser();
  bool isLoggedIn = user != null && user.phone != null && user.phone!.isNotEmpty;

  runApp(PurixAcademyApp(isLoggedIn: isLoggedIn));
}

class PurixAcademyApp extends StatelessWidget {
  final bool isLoggedIn;

  const PurixAcademyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}