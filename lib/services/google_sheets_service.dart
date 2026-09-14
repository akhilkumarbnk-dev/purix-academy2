import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/models/content_model.dart';

class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();

  factory GoogleSheetsService() {
    return _instance;
  }

  GoogleSheetsService._internal();

  // ===== POST USER DATA =====
  Future<Map<String, dynamic>> postUserData(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.GOOGLE_APPS_SCRIPT_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': user.name,
          'phone': user.phone,
          'email': user.email,
          'selected_class': user.selectedClass,
          'language': user.language,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to save user data'};
      }
    } catch (e) {
      print('Error posting user data: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // ===== GET CONTENT BY CLASS =====
  Future<List<ContentModel>> getContentByClass(String className) async {
    try {
      final sheetName = className.replaceAll(' ', '').replaceAll('th', ''); // Class 8 -> Class8
      final response = await http.get(
        Uri.parse('${AppConfig.GOOGLE_APPS_SCRIPT_URL}?sheet=${sheetName}_Content'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ContentModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching content: $e');
      return [];
    }
  }

  // ===== GET SUBJECTS BY CLASS =====
  Future<List<String>> getSubjectsByClass(String className) async {
    try {
      final content = await getContentByClass(className);
      final subjects = <String>{};
      
      for (var item in content) {
        if (item.subject != null && item.subject!.isNotEmpty) {
          subjects.add(item.subject!);
        }
      }
      
      return subjects.toList();
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }

  // ===== GET SUB-SUBJECTS BY SUBJECT =====
  Future<List<String>> getSubSubjectsBySubject(String className, String subject) async {
    try {
      final content = await getContentByClass(className);
      final subSubjects = <String>{};
      
      for (var item in content) {
        if (item.subject == subject && 
            item.subSubject != null && 
            item.subSubject!.isNotEmpty) {
          subSubjects.add(item.subSubject!);
        }
      }
      
      return subSubjects.toList();
    } catch (e) {
      print('Error fetching sub-subjects: $e');
      return [];
    }
  }

  // ===== GET CHAPTERS BY SUBJECT/SUB-SUBJECT =====
  Future<List<ContentModel>> getChaptersBySubject(
    String className,
    String subject,
    String? subSubject,
  ) async {
    try {
      final content = await getContentByClass(className);
      final chapters = <ContentModel>[];
      
      for (var item in content) {
        if (item.subject == subject) {
          if (subSubject != null && subSubject.isNotEmpty) {
            // If sub-subject is provided, filter by it
            if (item.subSubject == subSubject) {
              chapters.add(item);
            }
          } else {
            // If no sub-subject, include all (for English, Hindi)
            chapters.add(item);
          }
        }
      }
      
      return chapters;
    } catch (e) {
      print('Error fetching chapters: $e');
      return [];
    }
  }

  // ===== GET CONTENT BY TYPE (MCQ, NOTES, TEST) =====
  Future<List<ContentModel>> getContentByType(
    String className,
    String subject,
    String? subSubject,
    String type,
  ) async {
    try {
      final chapters = await getChaptersBySubject(className, subject, subSubject);
      return chapters.where((item) => item.type == type).toList();
    } catch (e) {
      print('Error fetching content by type: $e');
      return [];
    }
  }

  // ===== GET FREE CONTENT FOR CLASS =====
  Future<Map<String, List<ContentModel>>> getFreeSectionContent(String className) async {
    try {
      final content = await getContentByClass(className);
      final freeContent = <String, List<ContentModel>>{};
      
      // Filter only free content
      final free = content.where((item) => item.isFreeContent()).toList();
      
      // Group by subject
      final subjects = <String>{};
      for (var item in free) {
        if (item.subject != null) subjects.add(item.subject!);
      }
      
      for (var subject in subjects) {
        freeContent[subject] = free.where((item) => item.subject == subject).toList();
      }
      
      return freeContent;
    } catch (e) {
      print('Error fetching free content: $e');
      return {};
    }
  }

  // ===== GET USER DATA BY PHONE =====
  Future<UserModel?> getUserByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.GOOGLE_APPS_SCRIPT_URL}?sheet=User_ID'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        for (var item in data) {
          if (item['Phone'] == phone || item['phone'] == phone) {
            return UserModel.fromJson(item);
          }
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // ===== UPDATE USER CLASS =====
  Future<Map<String, dynamic>> updateUserClass(
    String phone,
    String newClass,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.GOOGLE_APPS_SCRIPT_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'selected_class': newClass,
          'action': 'update_class',
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to update class'};
      }
    } catch (e) {
      print('Error updating class: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}