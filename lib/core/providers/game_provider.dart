import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  int _totalCoins = 100;
  int _currentStageIndex = 0;

  String get currentLanguage => _currentLanguage;
  int get totalCoins => _totalCoins;
  int get currentStageIndex => _currentStageIndex;

  Future<void> loadGameSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('game_lang') ?? 'en';
    _totalCoins = prefs.getInt('game_coins') ?? 100;
    _currentStageIndex = prefs.getInt('game_stage') ?? 0;
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    _currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('game_lang', langCode);
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _totalCoins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('game_coins', _totalCoins);
    notifyListeners();
  }

  Future<void> useCoins(int amount) async {
    if (_totalCoins >= amount) {
      _totalCoins -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('game_coins', _totalCoins);
      notifyListeners();
    }
  }

  Future<void> moveToNextStage() async {
    _currentStageIndex++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('game_stage', _currentStageIndex);
    notifyListeners();
  }

  Future<void> resetGame() async {
    _currentLanguage = 'en';
    _totalCoins = 100;
    _currentStageIndex = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
