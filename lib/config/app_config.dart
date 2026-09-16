class AppConfig {
  // ========== OFFICE DETAILS - यहाँ तुम्हारे office का data डालो ==========
  
  // Google Apps Script Deployment URL (Office का)
  static const String GOOGLE_APPS_SCRIPT_URL = 
      'https://script.google.com/macros/d/https://script.google.com/macros/s/AKfycbz5UuMCqBQ9xw0o3D7eDC3TLo47GJhgbpJLDCRFXh62969rziQImt_RgEOJS23BK_wJ/exec/userweb'; 
  // ⬆️ इसे replace करो: YOUR_OFFICE_SCRIPT_ID को office की script ID से

  // Office का Google Sheets ID
  static const String SPREADSHEET_ID = 
      '1wD4wbyETaQW_oAHsAWI58vAF_u-G4J1_2G3ratmq1Eo';

  // Office का Phone Number (WhatsApp के लिए)
  static const String WHATSAPP_NUMBER = '9508774890';
  // ⬆️ इसे replace करो: office का 10-digit number
  
  static const String WHATSAPP_URL = 'https://wa.me/919508774890';
  // ⬆️ इसे replace करो: 91 + office number

  // Office की UPI ID
  static const String UPI_ID = '6201161834@ptyes';
  // ⬆️ इसे replace करो: office की UPI ID

  // Payment
  static const String PRO_PASS_PRICE = '₹599';
  static const int PRO_PASS_VALIDITY_DAYS = 30;

  // App Info (ये same रहेगी)
  static const String APP_NAME = 'PURIX ACADEMY';
  static const String APP_VERSION = '1.0.0';
  static const String APP_TAGLINE = 'NEW WAY OF LEARNING';

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