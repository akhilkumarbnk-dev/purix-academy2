class UserModel {
  String? phone;
  String? name;
  String? email;
  String? selectedClass;
  String? language;
  String? subscriptionStatus;
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;

  UserModel({
    this.phone,
    this.name,
    this.email,
    this.selectedClass,
    this.language,
    this.subscriptionStatus,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
      'email': email,
      'selected_class': selectedClass,
      'language': language,
      'subscription_status': subscriptionStatus,
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
    };
  }

  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['Phone'] ?? json['phone'],
      name: json['Name'] ?? json['name'],
      email: json['Email'] ?? json['email'],
      selectedClass: json['Selected_Class'] ?? json['selected_class'],
      language: json['Language'] ?? json['language'],
      subscriptionStatus: json['Subscription_Status'] ?? json['subscription_status'],
      subscriptionStartDate: json['Subscription_Start_Date'] != null
          ? DateTime.parse(json['Subscription_Start_Date'].toString())
          : null,
      subscriptionEndDate: json['Subscription_End_Date'] != null
          ? DateTime.parse(json['Subscription_End_Date'].toString())
          : null,
    );
  }

  // Check if user is valid
  bool isValid() {
    return phone != null && phone!.isNotEmpty && name != null && name!.isNotEmpty;
  }

  // Get initials
  String getInitials() {
    if (name == null || name!.isEmpty) return '?';
    List<String> nameParts = name!.split(' ');
    return nameParts
        .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
        .join()
        .substring(0, 1);
  }

  // Copy with changes
  UserModel copyWith({
    String? phone,
    String? name,
    String? email,
    String? selectedClass,
    String? language,
    String? subscriptionStatus,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
  }) {
    return UserModel(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      selectedClass: selectedClass ?? this.selectedClass,
      language: language ?? this.language,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
    );
  }
}