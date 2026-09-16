import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/services/pdf_service.dart';

class ContentViewerScreen extends StatefulWidget {
  final ContentModel content;

  ContentViewerScreen({required this.content});

  @override
  State<ContentViewerScreen> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  final _pdfService = PdfService();
  final _localStorageService = LocalStorageService();
  
  String _language = 'ENG';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final language = await _localStorageService.getLanguagePreference();
    setState(() => _language = language);
  }

  Future<void> _openPdf() async {
    final url = _language == 'HIN'
        ? widget.content.linkHin ?? widget.content.linkEng
        : widget.content.linkEng ?? widget.content.linkHin;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No link available for this content')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await _pdfService.openPdf(url);

    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open PDF')),
      );
    }
  }

  void _toggleLanguage() async {
    final newLanguage = _language == 'ENG' ? 'HIN' : 'ENG';
    await _localStorageService.saveLanguagePreference(newLanguage);
    setState(() => _language = newLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final title =
        _language == 'HIN' ? widget.content.titleHin : widget.content.titleEng;
    final link =
        _language == 'HIN' ? widget.content.linkHin : widget.content.linkEng;

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Content'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _language,
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            // Content Info
            Container(
              width: double.infinity,
              color: AppTheme.surfaceColor,
              padding: EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content.type ?? 'Content',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title ?? 'No Title',
                    style: AppTheme.headingSmall,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.content.isFreeContent()
                              ? AppTheme.successColor
                              : AppTheme.tertiaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.content.isFreeContent() ? 'FREE' : 'PAID',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.spacingL),

            // Open Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _openPdf,
                  icon: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              AppTheme.backgroundColor,
                            ),
                          ),
                        )
                      : Icon(Icons.open_in_new),
                  label: Text(
                    link == null || link.isEmpty ? 'NO LINK' : 'OPEN PDF',
                  ),
                ),
              ),
            ),

            SizedBox(height: AppTheme.spacingL),

            // Content Details
            if (widget.content.chapter != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.content.chapter ?? '',
                        style: AppTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}