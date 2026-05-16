import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/game_data.dart';
import '../../core/models/stage_model.dart';
import '../../core/providers/game_provider.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/audio_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _userAnswerLetters = [];
  List<int> _selectedScrambledIndices = [];

  void _initStage(StageModel stage) {
    _userAnswerLetters = List.generate(stage.correctAnswer.length, (_) => '');
    _selectedScrambledIndices.clear();
  }

  void _onLetterTap(int index, String letter, StageModel stage, GameProvider provider) {
    AudioService.playQuantumTap();
    int emptyIndex = _userAnswerLetters.indexOf('');
    if (emptyIndex != -1) {
      setState(() {
        _userAnswerLetters[emptyIndex] = letter;
        _selectedScrambledIndices.add(index);
      });
      _checkAnswer(stage, provider);
    }
  }

  void _removeLetter(int index) {
    if (_userAnswerLetters[index].isNotEmpty) {
      AudioService.playQuantumTap();
      setState(() {
        _userAnswerLetters[index] = '';
        if (_selectedScrambledIndices.isNotEmpty) {
          _selectedScrambledIndices.removeLast();
        }
      });
    }
  }

  void _checkAnswer(StageModel stage, GameProvider provider) {
    String currentAnswer = _userAnswerLetters.join('');
    if (currentAnswer == stage.correctAnswer) {
      AudioService.playGalaxyWinSequence();
      provider.addCoins(stage.rewardCoins);
      _showWinDialog(stage, provider);
    }
  }

  void _showWinDialog(StageModel stage, GameProvider provider) {
    bool isAr = provider.currentLanguage == 'ar';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.nebulaPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.starGold, width: 1.5),
        ),
        title: Text(
          isAr ? 'انتصار كوني مذهل! 🌌' : 'Galaxy Victory! 🌌',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.starGold, size: 60),
            const SizedBox(height: 15),
            Text(
              isAr ? 'تم فك شفرة اللغز بنجاح!' : 'You decrypted the cosmic puzzle!',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              '+${stage.rewardCoins} ${isAr ? 'عملة كونية' : 'Cosmic Coins'}',
              style: const TextStyle(color: AppColors.neonCyan, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await AdService.launchWormholeInterstitial(context, provider.currentLanguage);
                provider.moveToNextStage();
                setState(() {});
              },
              child: Text(
                isAr ? 'المرحلة التالية 🚀' : 'NEXT STAGE 🚀',
                style: const TextStyle(color: AppColors.spaceDark, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerHint(StageModel stage, GameProvider provider) async {
    if (provider.totalCoins >= 30) {
      provider.useCoins(30);
      _revealLetter(stage);
    } else {
      bool adWatched = await AdService.triggerQuantumRewardAd(context, provider.currentLanguage);
      if (adWatched) {
        _revealLetter(stage);
      }
    }
  }

  void _revealLetter(StageModel stage) {
    AudioService.playSuccessLetterPulse();
    for (int i = 0; i < stage.correctAnswer.length; i++) {
      if (_userAnswerLetters[i].isEmpty) {
        setState(() {
          _userAnswerLetters[i] = stage.correctAnswer[i];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final isAr = gameProvider.currentLanguage == 'ar';
    final stages = isAr ? GameData.galaxyStagesAr : GameData.galaxyStagesEn;

    if (gameProvider.currentStageIndex >= stages.length) {
      return Scaffold(
        backgroundColor: AppColors.spaceDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, size: 80, color: AppColors.starGold),
                const SizedBox(height: 20),
                Text(
                  isAr ? 'تهانينا يا كابتن!' : 'Congratulations Captain!',
                  style: const TextStyle(color: AppColors.textWhite, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  isAr ? 'لقد أنهيت جميع مراحل المجرة الحالية بنجاح.' : 'You have successfully conquered all stages in this galaxy.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonCyan),
                  onPressed: () => Navigator.pop(context),
                  child: Text(isAr ? 'العودة للقائمة' : 'RETURN TO MENU', style: const TextStyle(color: AppColors.spaceDark)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentStage = stages[gameProvider.currentStageIndex];
    if (_userAnswerLetters.length != currentStage.correctAnswer.length) {
      _initStage(currentStage);
    }

    return Scaffold(
      backgroundColor: AppColors.spaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.nebulaPurple,
        elevation: 0,
        title: Text('${isAr ? 'المرحلة' : 'Stage'} ${gameProvider.currentStageIndex + 1}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.stars, color: AppColors.starGold, size: 20),
                const SizedBox(width: 5),
                Text('${gameProvider.totalCoins}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.spaceDark, AppColors.cosmicBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: AppColors.cosmicBlue.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    currentStage.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textWhite, fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: List.generate(currentStage.correctAnswer.length, (index) {
                      return GestureDetector(
                        onTap: () => _removeLetter(index),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.nebulaPurple,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _userAnswerLetters[index].isNotEmpty ? AppColors.neonCyan : AppColors.textGrey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _userAnswerLetters[index],
                              style: const TextStyle(color: AppColors.textWhite, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: List.generate(currentStage.scrambledLetters.length, (index) {
                      bool isSelected = _selectedScrambledIndices.contains(index);
                      return GestureDetector(
                        onTap: isSelected ? null : () => _onLetterTap(index, currentStage.scrambledLetters[index], currentStage, gameProvider),
                        child: Opacity(
                          opacity: isSelected ? 0.3 : 1.0,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.cosmicBlue,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.textGrey.withOpacity(0.5)),
                            ),
                            child: Center(
                              child: Text(
                                currentStage.scrambledLetters[index],
                                style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starGold,
                      foregroundColor: AppColors.spaceDark,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _triggerHint(currentStage, gameProvider),
                    icon: const Icon(Icons.lightbulb),
                    label: Text(
                      isAr ? 'كشف حرف كوني (30🪙)' : 'Cosmic Hint (30🪙)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
