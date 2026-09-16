import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/sub_subject_screen.dart';
import 'package:purix_academy/widgets/subject_card.dart';

class SubjectScreen extends StatefulWidget {
  final String contentType; // MCQ, Notes, Test Series

  SubjectScreen({required this.contentType});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _sheetsService = GoogleSheetsService();
  final _localStorageService = LocalStorageService();
  
  List<String> _subjects = [];
  bool _isLoading = true;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _localStorageService.getUser();
    setState(() => _user = user);

    if (user != null) {
      final subjects = await _sheetsService.getSubjectsByClass(user.selectedClass ?? 'Class 8');
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_user?.selectedClass ?? 'Class 8'} - ${widget.contentType.toUpperCase()}'),
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
            : _subjects.isEmpty
                ? Center(
                    child: Text(
                      'No subjects available',
                      style: AppTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacingL),
                    itemCount: _subjects.length,
                    itemBuilder: (context, index) {
                      final subject = _subjects[index];
                      return SubjectCard(
                        subject: subject,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubSubjectScreen(
                                subject: subject,
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