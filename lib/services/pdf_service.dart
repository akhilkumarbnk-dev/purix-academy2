import 'package:url_launcher/url_launcher.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();

  factory PdfService() {
    return _instance;
  }

  PdfService._internal();

  // ===== OPEN PDF (Google Drive or Direct Link) =====
  Future<bool> openPdf(String pdfUrl) async {
    try {
      if (pdfUrl.isEmpty) {
        print('PDF URL is empty');
        return false;
      }

      // Convert Google Drive link to preview format
      String finalUrl = pdfUrl;

      if (pdfUrl.contains('drive.google.com')) {
        // Extract file ID from Google Drive URL
        final fileId = _extractFileId(pdfUrl);
        if (fileId != null) {
          finalUrl = 'https://drive.google.com/file/d/$fileId/preview';
        }
      }

      // Launch URL
      if (await canLaunchUrl(Uri.parse(finalUrl))) {
        await launchUrl(
          Uri.parse(finalUrl),
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        print('Could not launch URL: $finalUrl');
        return false;
      }
    } catch (e) {
      print('Error opening PDF: $e');
      return false;
    }
  }

  // ===== EXTRACT FILE ID FROM GOOGLE DRIVE URL =====
  String? _extractFileId(String url) {
    try {
      if (url.contains('/d/')) {
        final parts = url.split('/d/');
        if (parts.length > 1) {
          final fileId = parts[1].split('/')[0];
          return fileId;
        }
      } else if (url.contains('id=')) {
        final parts = url.split('id=');
        if (parts.length > 1) {
          final fileId = parts[1].split('&')[0];
          return fileId;
        }
      }
      return null;
    } catch (e) {
      print('Error extracting file ID: $e');
      return null;
    }
  }

  // ===== GET PREVIEW URL =====
  String getPreviewUrl(String pdfUrl) {
    if (pdfUrl.isEmpty) return '';

    if (pdfUrl.contains('drive.google.com')) {
      final fileId = _extractFileId(pdfUrl);
      if (fileId != null) {
        return 'https://drive.google.com/file/d/$fileId/preview';
      }
    }

    return pdfUrl;
  }

  // ===== VALIDATE PDF URL =====
  bool isValidPdfUrl(String url) {
    if (url.isEmpty) return false;
    return url.contains('drive.google.com') || 
           url.endsWith('.pdf') ||
           url.contains('http');
  }
}