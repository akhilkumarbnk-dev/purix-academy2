import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/login_screen.dart';
import 'package:purix_academy/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  final localStorageService = LocalStorageService();
  await localStorageService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purix Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: FutureBuilder(
        future: _checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                color: AppTheme.backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PURIX ACADEMY',
                        style: AppTheme.headingMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 24),
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            // User logged in, go to dashboard
            return DashboardScreen();
          } else {
            // No user, go to login
            return LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> _checkUserLoggedIn() async {
    final localStorageService = LocalStorageService();
    final user = await localStorageService.getUser();
    return user != null && user.phone != null && user.phone!.isNotEmpty;
  }
}