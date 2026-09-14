import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/models/subscription_model.dart';
import 'package:purix_academy/config/app_config.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  // ===== INITIALIZE =====
  Future<void> initialize() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // ===== SAVE USER =====
  Future<void> saveUser(UserModel user) async {
    await initialize();
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString('user_data', userJson);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // ===== GET USER =====
  Future<UserModel?> getUser() async {
    await initialize();
    try {
      final userJson = _prefs.getString('user_data');
      if (userJson != null) {
        final userMap = jsonDecode(userJson);
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // ===== CLEAR USER =====
  Future<void> clearUser() async {
    await initialize();
    try {
      await _prefs.remove('user_data');
      await _prefs.remove('subscription_data');
    } catch (e) {
      print('Error clearing user: $e');
    }
  }

  // ===== SAVE SUBSCRIPTION =====
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    await initialize();
    try {
      final subJson = jsonEncode(subscription.toJson());
      await _prefs.setString('subscription_data', subJson);
    } catch (e) {
      print('Error saving subscription: $e');
    }
  }

  // ===== GET SUBSCRIPTION =====
  Future<SubscriptionModel?> getSubscription() async {
    await initialize();
    try {
      final subJson = _prefs.getString('subscription_data');
      if (subJson != null) {
        final subMap = jsonDecode(subJson);
        return SubscriptionModel.fromJson(subMap);
      }
      return null;
    } catch (e) {
      print('Error getting subscription: $e');
      return null;
    }
  }

  // ===== SAVE LANGUAGE PREFERENCE =====
  Future<void> saveLanguagePreference(String language) async {
    await initialize();
    try {
      await _prefs.setString('language', language);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  // ===== GET LANGUAGE PREFERENCE =====
  Future<String> getLanguagePreference() async {
    await initialize();
    try {
      return _prefs.getString('language') ?? 'ENG';
    } catch (e) {
      return 'ENG';
    }
  }

  // ===== CACHE CONTENT =====
  Future<void> cacheContent(String key, String data) async {
    await initialize();
    try {
      await _prefs.setString('cache_$key', data);
    } catch (e) {
      print('Error caching content: $e');
    }
  }

  // ===== GET CACHED CONTENT =====
  Future<String?> getCachedContent(String key) async {
    await initialize();
    try {
      return _prefs.getString('cache_$key');
    } catch (e) {
      return null;
    }
  }

  // ===== CLEAR CACHE =====
  Future<void> clearCache() async {
    await initialize();
    try {
      final keys = _prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('cache_')) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}