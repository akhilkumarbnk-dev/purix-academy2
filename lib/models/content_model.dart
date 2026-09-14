class ContentModel {
  String? id;
  String? subject;
  String? subSubject;
  String? chapter;
  String? type; // MCQ, Notes, Test Series
  String? titleHin;
  String? titleEng;
  String? linkHin;
  String? linkEng;
  String? isFree;
  String? accessType; // Free, Paid

  ContentModel({
    this.id,
    this.subject,
    this.subSubject,
    this.chapter,
    this.type,
    this.titleHin,
    this.titleEng,
    this.linkHin,
    this.linkEng,
    this.isFree,
    this.accessType,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'sub_subject': subSubject,
      'chapter': chapter,
      'type': type,
      'title_hin': titleHin,
      'title_eng': titleEng,
      'link_hin': linkHin,
      'link_eng': linkEng,
      'is_free': isFree,
      'access_type': accessType,
    };
  }

  // Convert from JSON (Google Sheets)
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['ID']?.toString() ?? '',
      subject: json['Subject']?.toString() ?? '',
      subSubject: json['Sub-subject']?.toString() ?? '',
      chapter: json['Chapter']?.toString() ?? '',
      type: json['Content Type'] ?? json['Type'] ?? '',
      titleHin: json['Title-hin']?.toString() ?? '',
      titleEng: json['Title-eng']?.toString() ?? '',
      linkHin: json['Drive-link-hin']?.toString() ?? '',
      linkEng: json['Drive-link-eng']?.toString() ?? '',
      isFree: json['Is-Free']?.toString() ?? 'No',
      accessType: json['Access Type']?.toString() ?? 'Free',
    );
  }

  // Get display title based on language
  String getTitle(String language) {
    if (language == 'HIN') {
      return titleHin ?? titleEng ?? chapter ?? '';
    }
    return titleEng ?? titleHin ?? chapter ?? '';
  }

  // Get link based on language
  String getLink(String language) {
    if (language == 'HIN') {
      return linkHin ?? linkEng ?? '';
    }
    return linkEng ?? linkHin ?? '';
  }

  // Check if content is free
  bool isFreeContent() {
    return isFree?.toUpperCase() == 'YES' || accessType?.toUpperCase() == 'FREE';
  }

  // Check if user has access
  bool hasAccess(bool isPro) {
    if (isFreeContent()) {
      return true;
    }
    return isPro;
  }

  // Copy with changes
  ContentModel copyWith({
    String? id,
    String? subject,
    String? subSubject,
    String? chapter,
    String? type,
    String? titleHin,
    String? titleEng,
    String? linkHin,
    String? linkEng,
    String? isFree,
    String? accessType,
  }) {
    return ContentModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      subSubject: subSubject ?? this.subSubject,
      chapter: chapter ?? this.chapter,
      type: type ?? this.type,
      titleHin: titleHin ?? this.titleHin,
      titleEng: titleEng ?? this.titleEng,
      linkHin: linkHin ?? this.linkHin,
      linkEng: linkEng ?? this.linkEng,
      isFree: isFree ?? this.isFree,
      accessType: accessType ?? this.accessType,
    );
  }
}