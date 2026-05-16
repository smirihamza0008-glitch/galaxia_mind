import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/game_provider.dart';
import '../../core/services/audio_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final isAr = gameProvider.currentLanguage == 'ar';

    return Scaffold(
      backgroundColor: AppColors.spaceDark,
      appTheme: ThemeData.dark(),
      appBar: AppBar(
        backgroundColor: AppColors.nebulaPurple,
        elevation: 0,
        title: Text(
          isAr ? 'إعدادات السفينة' : 'Cosmic Settings',
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan),
          onPressed: () {
            AudioService.playQuantumTap();
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.spaceDark, AppColors.nebulaPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const SizedBox(height: 10),
            Icon(
              Icons.blur_circular,
              size: 80,
              color: AppColors.neonCyan.withOpacity(0.8),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(isAr ? 'اللغة ونظام العرض' : 'Language & Display'),
            const SizedBox(height: 12),
            Card(
              color: AppColors.cosmicBlue.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('English', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Global Cosmic Standard', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      value: 'en',
                      groupValue: gameProvider.currentLanguage,
                      activeColor: AppColors.neonCyan,
                      onChanged: (value) {
                        if (value != null) {
                          AudioService.playSuccessLetterPulse();
                          gameProvider.changeLanguage(value);
                        }
                      },
                    ),
                    Divider(color: AppColors.neonCyan.withOpacity(0.2), height: 1),
                    RadioListTile<String>(
                      title: const Text('العربية', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                      subtitle: const Text('النظام الكوني العربي', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      value: 'ar',
                      groupValue: gameProvider.currentLanguage,
                      activeColor: AppColors.neonCyan,
                      onChanged: (value) {
                        if (value != null) {
                          AudioService.playSuccessLetterPulse();
                          gameProvider.changeLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(isAr ? 'منطقة الخطر الكونية' : 'Danger Zone'),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF2D111A).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: const Icon(Icons.refresh, color: Colors.redAccent),
                title: Text(
                  isAr ? 'تصفير التقدم والنقاط' : 'Reset All Progress',
                  style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isAr ? 'سيتم مسح جميع النقاط والمراحل الحالية' : 'Delete all coins and start from stage 1',
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textGrey),
                onTap: () {
                  AudioService.playNavigationError();
                  _showResetDialog(context, isAr, gameProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.starGold,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, bool isAr, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.nebulaPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent, width: 1),
        ),
        title: Text(
          isAr ? 'تأكيد التصفير؟' : 'Are you sure?',
          style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          isAr 
              ? 'هل أنت متأكد من رغبتك في تصفير اللعبة بالكامل؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'This action will erase all your achievements and collected cosmic coins permanently.',
          style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isAr ? 'إلغاء' : 'Cancel', style: const TextStyle(color: AppColors.textWhite)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  provider.resetGame();
                  Navigator.pop(context);
                },
                child: Text(
                  isAr ? 'تصفير الآن' : 'Reset Now',
                  style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
