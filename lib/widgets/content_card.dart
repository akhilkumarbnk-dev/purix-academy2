import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';

class ContentCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onTap;

  const ContentCard({
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        color: AppTheme.surfaceColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Type Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        border: Border.all(color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        content.type ?? 'CONTENT',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    // Free Badge
                    if (content.isFreeContent())
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          border: Border.all(color: AppTheme.successColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FREE',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),

                // Title (Primary Language)
                Text(
                  content.titleEng ?? content.titleHin ?? 'No Title',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),

                // Subtitle Info
                if (content.chapter != null && content.chapter!.isNotEmpty)
                  Text(
                    content.chapter!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),

                SizedBox(height: AppTheme.spacingM),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Subject Info
                    Expanded(
                      child: Text(
                        content.subject ?? 'Subject',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),

                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}