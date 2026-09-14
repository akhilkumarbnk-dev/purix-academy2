// 8. sub_subject_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/screens/chapter_screen.dart';

class SubSubjectScreen extends StatefulWidget {
  final String className;
  final String subject;

  const SubSubjectScreen({
    Key? key,
    required this.className,
    required this.subject,
  }) : super(key: key);

  @override
  State<SubSubjectScreen> createState() => _SubSubjectScreenState();
}

class _SubSubjectScreenState extends State<SubSubjectScreen> {
  final _sheetsService = GoogleSheetsService();
  bool _isLoading = true;
  List<String> _subSubjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubSubjects();
  }

  Future<void> _loadSubSubjects() async {
    final subs = await _sheetsService.getSubSubjectsBySubject(widget.className, widget.subject);
    if (mounted) {
      setState(() {
        _subSubjects = subs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subSubjects.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Choose Content Type for ${widget.subject}', style: AppTheme.headingSmall),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChapterScreen(
                                  className: widget.className,
                                  subject: widget.subject,
                                  contentType: 'Notes',
                                ),
                              ),
                            );
                          },
                          child: const Text('View Notes & Chapters'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _subSubjects.length,
                  itemBuilder: (context, index) {
                    final subSubject = _subSubjects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(subSubject, style: AppTheme.headingSmall),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterScreen(
                                className: widget.className,
                                subject: widget.subject,
                                subSubject: subSubject,
                                contentType: 'Notes',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}