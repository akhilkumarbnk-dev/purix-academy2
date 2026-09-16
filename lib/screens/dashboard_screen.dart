import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/config/app_config.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/services/subscription_service.dart';
import 'package:purix_academy/screens/subject_screen.dart';
import 'package:purix_academy/screens/profile_screen.dart';
import 'package:purix_academy/screens/free_section_screen.dart';
import 'package:purix_academy/widgets/core_module_card.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _localStorageService = LocalStorageService();
  final _subscriptionService = SubscriptionService();
  
  UserModel? _user;
  bool _isPro = false;
  int _remainingDays = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _localStorageService.getUser();
    final isPro = await _subscriptionService.isPro(user?.phone ?? '');
    final remainingDays = await _subscriptionService.getRemainingDays(user?.phone ?? '');

    setState(() {
      _user = user;
      _isPro = isPro;
      _remainingDays = remainingDays;
    });
  }

  void _openWhatsApp() async {
    final url = 'https://wa.me/${AppConfig.WHATSAPP_NUMBER}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToModule(String moduleName) {
    String contentType = '';
    switch (moduleName) {
      case 'MCQ':
        contentType = 'MCQ';
        break;
      case 'Test Series':
        contentType = 'Test Series';
        break;
      case 'Notes':
        contentType = 'Notes';
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubjectScreen(
          contentType: contentType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Welcome, ${_user?.name?.split(' ').first ?? 'Student'} 👋',
                  style: AppTheme.headingMedium,
                ),
                SizedBox(height: 6),
                Text(
                  _user?.selectedClass ?? 'Class 8',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // Target Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PURIX ACADEMY',
                            style: AppTheme.headingSmall,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'NEW WAY OF LEARNING',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'TARGET: 95%+',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // Core Modules
                Text(
                  'CORE MODULES',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),

                // Module Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppTheme.spacingM,
                  crossAxisSpacing: AppTheme.spacingM,
                  children: [
                    CoreModuleCard(
                      icon: Icons.bolt,
                      title: 'MCQ TEST',
                      subtitle: 'Timed Simulation',
                      color: AppTheme.primaryColor,
                      onTap: () => _navigateToModule('MCQ'),
                    ),
                    CoreModuleCard(
                      icon: Icons.hub,
                      title: 'PRACTICE SETS',
                      subtitle: 'Question Bank',
                      color: AppTheme.tertiaryColor,
                      onTap: () => _navigateToModule('Test Series'),
                    ),
                    CoreModuleCard(
                      icon: Icons.settings,
                      title: 'PURIX NOTES',
                      subtitle: 'Core Theory Data',
                      color: AppTheme.secondaryColor,
                      onTap: () => _navigateToModule('Notes'),
                    ),
                    CoreModuleCard(
                      icon: Icons.diamond,
                      title: 'FREE MATRIX',
                      subtitle: 'PYQs & Blueprint',
                      color: AppTheme.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FreeSectionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingL),

                // Pro Pass Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.tertiaryColor, width: 2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    color: AppTheme.surfaceColor,
                  ),
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: AppTheme.tertiaryColor),
                          SizedBox(width: 8),
                          Text(
                            'PURIX PRO PASS (${AppConfig.PRO_PASS_PRICE})',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.tertiaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Unlock all locked tests, complete formula sheets, and chapter assignment banks at just ${AppConfig.PRO_PASS_PRICE}.',
                        style: AppTheme.bodySmall,
                      ),
                      SizedBox(height: AppTheme.spacingM),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.tertiaryColor,
                          ),
                          onPressed: () {
                            // Show pro pass dialog
                            _showProPassDialog();
                          },
                          child: Text(
                            'GET PRO ACCESS NOW (${AppConfig.PRO_PASS_PRICE})',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),

                // Help Desk Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FloatingActionButton.extended(
                    onPressed: _openWhatsApp,
                    label: Text('HELP DESK'),
                    icon: Icon(Icons.chat),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProPassDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PURIX PRO PASS'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Valid for 30 days'),
            SizedBox(height: 12),
            Text('Price: ${AppConfig.PRO_PASS_PRICE}'),
            SizedBox(height: 12),
            Text('Unlock all premium content!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentDialog();
            },
            child: Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('UPI: ${AppConfig.UPI_ID}'),
            SizedBox(height: 16),
            Text('Send payment and screenshot to WhatsApp'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openWhatsApp();
            },
            child: Text('Send Screenshot'),
          ),
        ],
      ),
    );
  }
}