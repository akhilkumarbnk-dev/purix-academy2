import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';

class CoreModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const CoreModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        color: AppTheme.surfaceColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Title
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),

                // Subtitle
                Text(
                  subtitle,
                  style: AppTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}