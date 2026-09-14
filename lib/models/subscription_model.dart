class SubscriptionModel {
  final String? phone;
  final bool isPro;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? remainingDays;

  SubscriptionModel({
    this.phone,
    this.isPro = false,
    this.startDate,
    this.endDate,
    this.remainingDays,
  });

  // Check if subscription is expired
  bool isExpired() {
    if (endDate == null) return true;
    return DateTime.now().isAfter(endDate!);
  }

  // Get remaining days helper
  int getRemainingDays() {
    if (endDate == null) return 0;
    final diff = endDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  // Info text helper
  String getInfoText() {
    if (isPro && !isExpired()) {
      return 'PRO Member (${getRemainingDays()} days left)';
    }
    return 'FREE Member';
  }

  // copyWith method
  SubscriptionModel copyWith({
    String? phone,
    bool? isPro,
    DateTime? startDate,
    DateTime? endDate,
    int? remainingDays,
  }) {
    return SubscriptionModel(
      phone: phone ?? this.phone,
      isPro: isPro ?? this.isPro,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingDays: remainingDays ?? this.remainingDays,
    );
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      phone: json['phone'],
      isPro: json['isPro'] == true || json['status'] == 'PRO',
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      remainingDays: json['remainingDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'isPro': isPro,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'remainingDays': remainingDays,
    };
  }
}