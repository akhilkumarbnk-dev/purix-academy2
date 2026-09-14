// 1. widgets/chapter_card.dart
import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';

class ChapterCard extends StatelessWidget {
  final String title;
  final String type;
  final bool isFree;
  final bool hasAccess;
  final VoidCallback onTap;

  const ChapterCard({
    Key? key,
    required this.title,
    required this.type,
    required this.isFree,
    required this.hasAccess,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: AppTheme.headingSmall,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isFree
                      ? AppTheme.successColor.withOpacity(0.2)
                      : AppTheme.tertiaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isFree ? 'FREE' : 'PRO',
                  style: TextStyle(
                    color: isFree ? AppTheme.successColor : AppTheme.tertiaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ),
        trailing: Icon(
          hasAccess ? Icons.arrow_forward_ios : Icons.lock_outline,
          color: hasAccess ? AppTheme.primaryColor : AppTheme.errorColor,
        ),
        onTap: onTap,
      ),
    );
  }
}