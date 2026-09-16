import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';

class AppConstants {
  // App Info
  static const String APP_NAME = 'Purix Academy';
  static const String APP_VERSION = '1.0.0';
  static const String APP_TAGLINE = 'NEW WAY OF LEARNING';

  // Error Messages
  static const String ERROR_NETWORK = 'Network error. Please check your connection.';
  static const String ERROR_INVALID_PHONE = 'Please enter a valid 10-digit phone number.';
  static const String ERROR_INVALID_NAME = 'Please enter a valid name.';
  static const String ERROR_NO_DATA = 'No data available.';
  static const String ERROR_GENERIC = 'Something went wrong. Please try again.';

  // Success Messages
  static const String SUCCESS_LOGIN = 'Login successful!';
  static const String SUCCESS_REGISTRATION = 'Registration successful!';
  static const String SUCCESS_CLASS_UPDATED = 'Class updated successfully!';

  // Loading Messages
  static const String LOADING_PLEASE_WAIT = 'Please wait...';
  static const String LOADING_FETCHING_DATA = 'Fetching data...';

  // Animation Durations
  static const Duration ANIMATION_DURATION = Duration(milliseconds: 300);
  static const Duration TOAST_DURATION = Duration(seconds: 2);

  // Validation Rules
  static const int PHONE_LENGTH = 10;
  static const int MIN_NAME_LENGTH = 2;
  static const int MAX_NAME_LENGTH = 50;

  // Storage Keys
  static const String STORAGE_KEY_USER = 'user_data';
  static const String STORAGE_KEY_SUBSCRIPTION = 'subscription_data';
  static const String STORAGE_KEY_LANGUAGE = 'language';
  static const String STORAGE_KEY_THEME = 'theme';

  // API Endpoints
  static const String ENDPOINT_LOGIN = 'User_ID';
  static const String ENDPOINT_CONTENT = '_Content';

  // Subscription
  static const int SUBSCRIPTION_DAYS = 30;
  static const String SUBSCRIPTION_PRICE = '₹599';

  // Class Descriptions
  static final Map<String, String> CLASS_DESCRIPTIONS = {
    'Class 8': 'Foundation, Concepts & Practice',
    'Class 9': 'Pre-Board Core Concepts & Notes',
    'Class 10': 'Board Exam Mastery, High-Yield Qs',
    'Board Special': 'Target Crash Course, Formulas & Mock Tests',
  };

  // Subject Icons (Emoji)
  static final Map<String, String> SUBJECT_ICONS = {
    'Science': '🔬',
    'Social Science': '🌍',
    'English': '📚',
    'Hindi': '📖',
    'Physics': '⚛️',
    'Chemistry': '🧪',
    'Biology': '🧬',
    'History': '📜',
    'Geography': '🗺️',
    'Civics': '⚖️',
    'Economics': '💰',
  };

  // Content Type Icons
  static final Map<String, IconData> CONTENT_ICONS = {
    'MCQ': Icons.help_outline,
    'Notes': Icons.description,
    'Test Series': Icons.assessment,
    'PDF': Icons.picture_as_pdf,
  };

  // Content Type Colors
  static final Map<String, Color> CONTENT_COLORS = {
    'MCQ': AppTheme.primaryColor,
    'Notes': AppTheme.secondaryColor,
    'Test Series': AppTheme.tertiaryColor,
    'PDF': AppTheme.primaryColor,
  };
}