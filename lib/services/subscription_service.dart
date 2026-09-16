import 'package:purix_academy/models/subscription_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  
  final _localStorageService = LocalStorageService();

  factory SubscriptionService() {
    return _instance;
  }

  SubscriptionService._internal();

  // ===== CHECK SUBSCRIPTION STATUS =====
  Future<SubscriptionModel?> getSubscription(String phone) async {
    try {
      final subscription = await _localStorageService.getSubscription();
      
      if (subscription != null) {
        // Check if expired
        if (subscription.isExpired()) {
          // Update to FREE
          final updated = subscription.copyWith(
            status: 'FREE',
            isActive: false,
          );
          await _localStorageService.saveSubscription(updated);
          return updated;
        }
      }
      
      return subscription;
    } catch (e) {
      print('Error getting subscription: $e');
      return null;
    }
  }

  // ===== CHECK IF USER IS PRO =====
  Future<bool> isPro(String phone) async {
    try {
      final subscription = await getSubscription(phone);
      return subscription?.isPro() ?? false;
    } catch (e) {
      return false;
    }
  }

  // ===== GET REMAINING DAYS =====
  Future<int> getRemainingDays(String phone) async {
    try {
      final subscription = await getSubscription(phone);
      return subscription?.getRemainingDays() ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ===== ACTIVATE PRO PASS =====
  Future<Map<String, dynamic>> activateProPass(String phone) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: 30));

      final subscription = SubscriptionModel(
        phone: phone,
        status: 'PRO',
        startDate: now,
        endDate: endDate,
        remainingDays: 30,
        isActive: true,
      );

      await _localStorageService.saveSubscription(subscription);

      return {
        'success': true,
        'subscription': subscription,
        'message': 'PRO Pass activated for 30 days',
      };
    } catch (e) {
      print('Error activating PRO pass: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ===== GET SUBSCRIPTION INFO TEXT =====
  Future<String> getSubscriptionInfo(String phone) async {
    try {
      final subscription = await getSubscription(phone);
      return subscription?.getInfoText() ?? 'FREE Member';
    } catch (e) {
      return 'FREE Member';
    }
  }

  // ===== CHECK CONTENT ACCESS =====
  Future<bool> hasAccessToContent({
    required String phone,
    required bool isFreeContent,
  }) async {
    try {
      // Free content accessible to all
      if (isFreeContent) {
        return true;
      }

      // Paid content accessible only if PRO
      final isPro = await this.isPro(phone);
      return isPro;
    } catch (e) {
      return false;
    }
  }
}