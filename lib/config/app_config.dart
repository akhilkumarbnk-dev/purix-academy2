class AppConfig {
  // App Name
  static const String appName = 'Purix Academy';

  // Google Apps Script Deployment URL
  static const String GOOGLE_APPS_SCRIPT_URL = 
      'https://script.google.com/macros/s/AKfycbz5UuMCqBQ9xw0o3D7eDC3TLo47GJhgbpJLDCRFXh62969rziQImt_RgEOJS23BK_wJ/exec'; 

  // Google Sheets ID
  static const String SPREADSHEET_ID = 
      '1wD4wbyETaQW_oAHsAWI58vAF_u-G4J1_2G3ratmq1Eo';

  // Payment Details
  static const String UPI_ID = '6201161834@ptyes';
  static const String PRO_PASS_PRICE = '₹599';
  static const int PRO_PASS_VALIDITY_DAYS = 30;

  // Contact Details
  static const String WHATSAPP_NUMBER = '6201161834';
  static const String WHATSAPP_URL = 'https://wa.me/916201161834';

  // Classes
  static const List<String> CLASSES = [
    'Class 8',
    'Class 9',
    'Class 10',
    'Board Special'
  ];

  // Subjects
  static const Map<String, List<String>> SUBJECTS = {
    'Science': ['Physics', 'Chemistry', 'Biology'],
    'Social Science': ['History', 'Geography', 'Civics', 'Economics'],
    'English': [],
    'Hindi': []
  };

  // Content Types
  static const List<String> CONTENT_TYPES = ['MCQ', 'Notes', 'Test Series'];

  // Languages
  static const List<String> LANGUAGES = ['ENG', 'HIN'];

  // Local Storage Keys
  static const String USER_PHONE_KEY = 'user_phone';
  static const String USER_NAME_KEY = 'user_name';
  static const String USER_EMAIL_KEY = 'user_email';
  static const String USER_CLASS_KEY = 'user_class';
  static const String USER_LANGUAGE_KEY = 'user_language';
  static const String SUBSCRIPTION_STATUS_KEY = 'subscription_status';
}