import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/chapter_screen.dart';
import 'package:purix_academy/widgets/subject_card.dart';

class SubSubjectScreen extends StatefulWidget {
  final String subject;
  final String contentType;

  SubSubjectScreen({
    required this.subject,
    required this.contentType,
  });

  @override
  State<SubSubjectScreen> createState() => _SubSubjectScreenState();
}

class _SubSubjectScreenState extends State<SubSubjectScreen> {
  final _sheetsService = GoogleSheetsService();
  final _localStorageService = LocalStorageService();
  
  List<String> _subSubjects = [];
  bool _isLoading = true;
  UserModel? _user;
  bool _hasSubSubjects = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _localStorageService.getUser();
    setState(() => _user = user);

    if (user != null) {
      // Check if subject has sub-subjects
      final subSubjects = await _sheetsService.getSubSubjectsBySubject(
        user.selectedClass ?? 'Class 8',
        widget.subject,
      );

      setState(() {
        _subSubjects = subSubjects;
        _hasSubSubjects = subSubjects.isNotEmpty;
        _isLoading = false;
      });

      // If no sub-subjects, go directly to chapters
      if (!_hasSubSubjects) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChapterScreen(
                subject: widget.subject,
                subSubject: null,
                contentType: widget.contentType,
              ),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.toUpperCase()),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              )
            : _subSubjects.isEmpty
                ? Center(
                    child: Text(
                      'No sub-subjects available',
                      style: AppTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacingL),
                    itemCount: _subSubjects.length,
                    itemBuilder: (context, index) {
                      final subSubject = _subSubjects[index];
                      return SubjectCard(
                        subject: subSubject,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChapterScreen(
                                subject: widget.subject,
                                subSubject: subSubject,
                                contentType: widget.contentType,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}