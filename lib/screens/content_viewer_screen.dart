// 3. content_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/services/pdf_service.dart';

class ContentViewerScreen extends StatefulWidget {
  final String title;
  final String url;

  const ContentViewerScreen({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<ContentViewerScreen> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  final _pdfService = PdfService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              await _pdfService.openPdf(widget.url);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: AppTheme.headingSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Tap below to open or view the document.',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _pdfService.openPdf(widget.url);
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                icon: const Icon(Icons.download),
                label: const Text('Open Document / PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}