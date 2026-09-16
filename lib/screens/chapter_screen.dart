import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/screens/content_viewer_screen.dart';
import 'package:purix_academy/widgets/chapter_card.dart';

class ChapterScreen extends StatefulWidget {
  final String subject;
  final String? subSubject;
  final String contentType;

  ChapterScreen({
    required this.subject,
    this.subSubject,
    required this.contentType,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final _sheetsService = GoogleSheetsService();
  final _localStorageService = LocalStorageService();
  final _subscriptionService = SubscriptionService();
  
  List<ContentModel> _chapters = [];
  bool _isLoading = true;
  UserModel? _user;
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _localStorageService.getUser();
    setState(() => _user = user);

    if (user != null) {
      final isPro = await _subscriptionService.isPro(user.phone ?? '');
      final chapters = await _sheetsService.getContentByType(
        user.selectedClass ?? 'Class 8',
        widget.subject,
        widget.subSubject,
        widget.contentType,
      );

      setState(() {
        _chapters = chapters;
        _isPro = isPro;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subSubject != null
              ? '${widget.subject} - ${widget.subSubject}'
              : widget.subject,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
            : _chapters.isEmpty
                ? Center(
                    child: Text(
                      'No chapters available',
                      style: AppTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacingL),
                    itemCount: _chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = _chapters[index];
                      final hasAccess = chapter.hasAccess(_isPro);

                      return ChapterCard(
                        chapter: chapter,
                        hasAccess: hasAccess,
                        onTap: hasAccess
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ContentViewerScreen(content: chapter),
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  ),
      ),
    );
  }
}