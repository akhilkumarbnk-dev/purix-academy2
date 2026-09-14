import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/models/subscription_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';

class SubscriptionService {
  final _localStorage = LocalStorageService();

  // Check if user is PRO
  Future<bool> isPro(String phone) async {
    try {
      final sub = await getSubscriptionDetails(phone);
      return sub != null && sub.isPro && !sub.isExpired();
    } catch (e) {
      return false;
    }
  }

  // Get subscription info text for UI
  Future<String> getSubscriptionInfo(String phone) async {
    try {
      final sub = await getSubscriptionDetails(phone);
      if (sub != null) {
        return sub.getInfoText();
      }
      return 'FREE Member';
    } catch (e) {
      return 'FREE Member';
    }
  }

  // Get full subscription details from Google Sheets or Local Storage
  Future<SubscriptionModel?> getSubscriptionDetails(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.GOOGLE_APPS_SCRIPT_URL}?action=getSubscription&phone=$phone'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final model = SubscriptionModel.fromJson(data['data']);
          await _localStorage.saveSubscription(model);
          return model;
        }
      }
      
      // Fallback to local storage if network fails
      return await _localStorage.getSubscription();
    } catch (e) {
      return await _localStorage.getSubscription();
    }
  }

  // Request/Submit a new subscription payment/activation
  Future<Map<String, dynamic>> requestSubscription({
    required String phone,
    required String name,
    required String transactionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.GOOGLE_APPS_SCRIPT_URL),
        body: jsonEncode({
          'action': 'requestSubscription',
          'phone': phone,
          'name': name,
          'transactionId': transactionId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'error': 'Server error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}