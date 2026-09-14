// 9. subject_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/screens/sub_subject_screen.dart';

class SubjectScreen extends StatefulWidget {
  final String className;

  const SubjectScreen({Key? key, required this.className}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _sheetsService = GoogleSheetsService();
  bool _isLoading = true;
  List<String> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final subs = await _sheetsService.getSubjectsByClass(widget.className);
    if (mounted) {
      setState(() {
        _subjects = subs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purix Academy (${widget.className})'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subjects.isEmpty
              ? Center(
                  child: Text(
                    'No subjects available for ${widget.className}',
                    style: AppTheme.bodyMedium,
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubSubjectScreen(
                              className: widget.className,
                              subject: subject,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.book, size: 36, color: AppTheme.primaryColor),
                            const SizedBox(height: 12),
                            Text(
                              subject,
                              style: AppTheme.headingSmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}