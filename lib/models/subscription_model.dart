class SubscriptionModel {
  String? phone;
  String? status; // FREE, PRO
  DateTime? startDate;
  DateTime? endDate;
  int? remainingDays;
  bool? isActive;

  SubscriptionModel({
    this.phone,
    this.status,
    this.startDate,
    this.endDate,
    this.remainingDays,
    this.isActive,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'remaining_days': remainingDays,
      'is_active': isActive,
    };
  }

  // Convert from JSON (Google Sheets)
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    String status = json['Subscription_Status']?.toString() ?? 'FREE';
    DateTime? startDate;
    DateTime? endDate;

    try {
      if (json['Subscription_Start_Date'] != null) {
        startDate = DateTime.parse(json['Subscription_Start_Date'].toString());
      }
      if (json['Subscription_End_Date'] != null) {
        endDate = DateTime.parse(json['Subscription_End_Date'].toString());
      }
    } catch (e) {
      print('Error parsing subscription dates: $e');
    }

    int remainingDays = 0;
    bool isActive = false;

    if (endDate != null) {
      Duration difference = endDate.difference(DateTime.now());
      remainingDays = difference.inDays;
      isActive = remainingDays > 0;
    }

    return SubscriptionModel(
      phone: json['Phone']?.toString() ?? '',
      status: status,
      startDate: startDate,
      endDate: endDate,
      remainingDays: remainingDays,
      isActive: isActive,
    );
  }

  // Check if subscription is expired
  bool isExpired() {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  // Check if user is PRO
  bool isPro() {
    return status?.toUpperCase() == 'PRO' && isActive == true;
  }

  // Get remaining days
  int getRemainingDays() {
    if (endDate == null) return 0;
    Duration difference = endDate!.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  // Get subscription info text
  String getInfoText() {
    if (status?.toUpperCase() == 'FREE') {
      return 'FREE Member';
    }
    
    int days = getRemainingDays();
    if (days > 0) {
      return 'PRO Member • $days days left';
    }
    
    return 'Subscription Expired';
  }

  // Copy with changes
  SubscriptionModel copyWith({
    String? phone,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? remainingDays,
    bool? isActive,
  }) {
    return SubscriptionModel(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingDays: remainingDays ?? this.remainingDays,
      isActive: isActive ?? this.isActive,
    );
  }
}