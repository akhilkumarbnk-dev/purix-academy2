import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/content_model.dart';

class ChapterCard extends StatelessWidget {
  final ContentModel chapter;
  final bool hasAccess;
  final VoidCallback? onTap;

  const ChapterCard({
    required this.chapter,
    required this.hasAccess,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.borderColor,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        color: AppTheme.surfaceColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasAccess
              ? onTap
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Upgrade to PRO to access this content'),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type and access badge
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
                        chapter.type ?? 'CONTENT',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    // Access Badge
                    if (!hasAccess)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryColor.withOpacity(0.1),
                          border: Border.all(color: AppTheme.tertiaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LOCKED',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.tertiaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                    else if (chapter.isFreeContent())
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

                // Chapter Title
                Text(
                  chapter.chapter ?? 'No Title',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),

                // Sub-subtitle if available
                if (chapter.subSubject != null && chapter.subSubject!.isNotEmpty)
                  Text(
                    chapter.subSubject!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),

                SizedBox(height: AppTheme.spacingM),

                // Bottom Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Link Status
                    Expanded(
                      child: Text(
                        (chapter.linkEng ?? '').isEmpty &&
                                (chapter.linkHin ?? '').isEmpty
                            ? 'No link available'
                            : 'Link available',
                        style: AppTheme.bodySmall.copyWith(
                          color: (chapter.linkEng ?? '').isEmpty &&
                                  (chapter.linkHin ?? '').isEmpty
                              ? AppTheme.errorColor
                              : AppTheme.successColor,
                        ),
                      ),
                    ),

                    // Arrow or Lock Icon
                    if (hasAccess)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.primaryColor,
                        size: 16,
                      )
                    else
                      Icon(
                        Icons.lock,
                        color: AppTheme.tertiaryColor,
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