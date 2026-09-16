import 'package:intl/intl.dart';

class AppHelpers {
  // Validate Phone Number
  static bool isValidPhone(String phone) {
    return phone.isNotEmpty && phone.length == 10 && int.tryParse(phone) != null;
  }

  // Validate Email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return true; // Email is optional
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validate Name
  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2 && name.length <= 50;
  }

  // Format Date
  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Format DateTime
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy - HH:mm').format(dateTime);
  }

  // Get Relative Time (e.g., "2 days ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(dateTime);
    }
  }

  // Get Greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Calculate Remaining Subscription Days
  static int calculateRemainingDays(DateTime? endDate) {
    if (endDate == null) return 0;
    final now = DateTime.now();
    final difference = endDate.difference(now);
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  // Check if Subscription is Expired
  static bool isSubscriptionExpired(DateTime? endDate) {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate);
  }

  // Format Phone Number
  static String formatPhoneNumber(String phone) {
    if (phone.length != 10) return phone;
    return '${phone.substring(0, 5)} ${phone.substring(5)}';
  }

  // Capitalize First Letter
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Get Initials from Name
  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    return parts
        .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
        .join()
        .substring(0, 1);
  }

  // Truncate Text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Convert List to String
  static String listToString(List<String> list) {
    return list.join(', ');
  }

  // Check Internet Connectivity (would need connectivity package)
  // static Future<bool> isConnectedToInternet() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //   } on SocketException catch (_) {
  //     return false;
  //   }
  // }

  // Generate Random ID
  static String generateRandomId(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    final random = List.generate(length, (index) {
      return chars[(index * 7) % chars.length];
    }).join();
    return random;
  }

  // Pluralize
  static String pluralize(int count, String singular, {String? plural}) {
    if (count == 1) {
      return '$count $singular';
    } else {
      return '$count ${plural ?? singular + 's'}';
    }
  }
}