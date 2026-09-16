import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/screens/content_viewer_screen.dart';
import 'package:purix_academy/widgets/content_card.dart';

class FreeSectionScreen extends StatefulWidget {
  @override
  State<FreeSectionScreen> createState() => _FreeSectionScreenState();
}

class _FreeSectionScreenState extends State<FreeSectionScreen> {
  final _sheetsService = GoogleSheetsService();
  final _localStorageService = LocalStorageService();

  Map<String, List<ContentModel>> _freeContent = {};
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
      final freeContent = await _sheetsService.getFreeSectionContent(
        user.selectedClass ?? 'Class 8',
      );

      setState(() {
        _freeContent = freeContent;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FREE SECTION'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            // Subtitle Section (नीचे AppBar के)
            Container(
              width: double.infinity,
              color: AppTheme.surfaceColor,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
                vertical: AppTheme.spacingM,
              ),
              child: Text(
                'All FREE content for ${_user?.selectedClass ?? 'Class 8'}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            
            // Content Section
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                      ),
                    )
                  : _freeContent.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: AppTheme.textSecondaryColor,
                              ),
                              SizedBox(height: AppTheme.spacingM),
                              Text(
                                'No free content available',
                                style: AppTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(AppTheme.spacingL),
                          itemCount: _freeContent.length,
                          itemBuilder: (context, subjectIndex) {
                            final subject = _freeContent.keys.toList()[subjectIndex];
                            final contents = _freeContent[subject] ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Subject Header
                                Text(
                                  subject.toUpperCase(),
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.primaryColor,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppTheme.spacingM),

                                // Content List
                                ...contents.map((content) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: AppTheme.spacingM,
                                    ),
                                    child: ContentCard(
                                      content: content,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ContentViewerScreen(content: content),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),

                                SizedBox(height: AppTheme.spacingL),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}