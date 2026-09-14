// 5. free_section_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';
import 'package:purix_academy/services/google_sheets_service.dart';
import 'package:purix_academy/services/auth_service.dart';
import 'package:purix_academy/services/pdf_service.dart';

class FreeSectionScreen extends StatefulWidget {
  const FreeSectionScreen({Key? key}) : super(key: key);

  @override
  State<FreeSectionScreen> createState() => _FreeSectionScreenState();
}

class _FreeSectionScreenState extends State<FreeSectionScreen> {
  final _sheetsService = GoogleSheetsService();
  final _authService = AuthService();
  final _pdfService = PdfService();

  bool _isLoading = true;
  Map<String, List<ContentModel>> _freeContent = {};
  String _userLanguage = 'ENG';
  String _selectedClass = 'Class 10';

  @override
  void initState() {
    super.initState();
    _loadFreeContent();
  }

  Future<void> _loadFreeContent() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      _userLanguage = user.language ?? 'ENG';
      _selectedClass = user.selectedClass ?? 'Class 10';
    }

    final content = await _sheetsService.getFreeSectionContent(_selectedClass);

    if (mounted) {
      setState(() {
        _freeContent = content;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Study Zone'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _freeContent.isEmpty
              ? Center(
                  child: Text(
                    'No free content available right now.',
                    style: AppTheme.bodyMedium,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: _freeContent.entries.map((entry) {
                    final subject = entry.key;
                    final items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            subject,
                            style: AppTheme.headingSmall,
                          ),
                        ),
                        ...items.map((item) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(item.getTitle(_userLanguage)),
                              subtitle: Text('Type: ${item.type ?? "Notes"}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () async {
                                final link = item.getLink(_userLanguage);
                                if (link.isNotEmpty) {
                                  await _pdfService.openPdf(link);
                                }
                              },
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
    );
  }
}