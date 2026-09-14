// 6. mcq_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/services/pdf_service.dart';

class McqScreen extends StatefulWidget {
  final String className;
  final String subject;
  final String? subSubject;

  const McqScreen({
    Key? key,
    required this.className,
    required this.subject,
    this.subSubject,
  }) : super(key: key);

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  final _sheetsService = GoogleSheetsService();
  final _authService = AuthService();
  final _subService = SubscriptionService();
  final _pdfService = PdfService();

  bool _isLoading = true;
  List<ContentModel> _mcqs = [];
  String _userLanguage = 'ENG';
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _loadMcqs();
  }

  Future<void> _loadMcqs() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      _userLanguage = user.language ?? 'ENG';
      _isPro = await _subService.isPro(user.phone ?? '');
    }

    final content = await _sheetsService.getContentByType(
      widget.className,
      widget.subject,
      widget.subSubject,
      'MCQ',
    );

    if (mounted) {
      setState(() {
        _mcqs = content;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} - MCQs'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mcqs.isEmpty
              ? Center(
                  child: Text(
                    'No MCQs available.',
                    style: AppTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _mcqs.length,
                  itemBuilder: (context, index) {
                    final mcq = _mcqs[index];
                    final title = mcq.getTitle(_userLanguage);
                    final isFree = mcq.isFreeContent();
                    final hasAccess = isFree || _isPro;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(title, style: AppTheme.headingSmall),
                        trailing: Icon(
                          hasAccess ? Icons.quiz : Icons.lock_outline,
                          color: hasAccess ? AppTheme.primaryColor : AppTheme.errorColor,
                        ),
                        onTap: () async {
                          if (hasAccess) {
                            final link = mcq.getLink(_userLanguage);
                            if (link.isNotEmpty) {
                              await _pdfService.openPdf(link);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PRO Pass required for these MCQs')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}