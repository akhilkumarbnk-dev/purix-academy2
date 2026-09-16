import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';

class SubjectCard extends StatelessWidget {
  final String subject;
  final VoidCallback onTap;
  final Color? color;

  const SubjectCard({
    required this.subject,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primaryColor;

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        border: Border.all(
          color: cardColor.withOpacity(0.3),
        ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon & Title
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.book,
                          color: cardColor,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingM),

                    // Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap to view chapters & topics',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textSecondaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}