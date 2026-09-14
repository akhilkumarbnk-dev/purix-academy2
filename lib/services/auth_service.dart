import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  final _googleSheetsService = GoogleSheetsService();
  final _localStorageService = LocalStorageService();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // ===== REGISTER USER =====
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String email,
    required String selectedClass,
    String language = 'ENG',
  }) async {
    try {
      // Validate input
      if (name.isEmpty || phone.isEmpty) {
        return {'success': false, 'error': 'Name and phone are required'};
      }

      if (phone.length != 10) {
        return {'success': false, 'error': 'Phone number must be 10 digits'};
      }

      // Create user model
      final user = UserModel(
        name: name,
        phone: phone,
        email: email.isNotEmpty ? email : 'N/A',
        selectedClass: selectedClass,
        language: language,
        subscriptionStatus: 'FREE',
        subscriptionStartDate: DateTime.now(),
        subscriptionEndDate: DateTime.now().add(Duration(days: 30)),
      );

      // Post to Google Sheets
      final result = await _googleSheetsService.postUserData(user);

      if (result['success'] == true) {
        // Save to local storage
        await _localStorageService.saveUser(user);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'error': result['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      print('Error registering user: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ===== LOGIN USER (Check if exists) =====
  Future<Map<String, dynamic>> loginUser({
    required String phone,
  }) async {
    try {
      // Check if user exists in Google Sheets
      final user = await _googleSheetsService.getUserByPhone(phone);

      if (user != null) {
        // Save to local storage
        await _localStorageService.saveUser(user);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'error': 'User not found'};
      }
    } catch (e) {
      print('Error logging in user: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ===== GET CURRENT USER =====
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _localStorageService.getUser();
      return user;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // ===== UPDATE USER CLASS =====
  Future<Map<String, dynamic>> updateUserClass({
    required String phone,
    required String newClass,
  }) async {
    try {
      final result = await _googleSheetsService.updateUserClass(phone, newClass);

      if (result['success'] == true) {
        // Update local storage
        final user = await _localStorageService.getUser();
        if (user != null) {
          final updatedUser = user.copyWith(selectedClass: newClass);
          await _localStorageService.saveUser(updatedUser);
        }
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to update class'};
      }
    } catch (e) {
      print('Error updating user class: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ===== LOGOUT USER =====
  Future<void> logoutUser() async {
    try {
      await _localStorageService.clearUser();
    } catch (e) {
      print('Error logging out user: $e');
    }
  }

  // ===== CHECK IF USER LOGGED IN =====
  Future<bool> isUserLoggedIn() async {
    try {
      final user = await _localStorageService.getUser();
      return user != null && user.phone != null && user.phone!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}