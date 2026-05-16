import 'package:flutter/services.dart';

class AudioService {
  static void playQuantumTap() {
    SystemSound.play(SystemSoundType.click);
  }

  static void playSuccessLetterPulse() {
    HapticFeedback.selectionClick();
  }

  static void playNavigationError() {
    HapticFeedback.vibrate();
  }

  static void playGalaxyWinSequence() {
    HapticFeedback.successImpact();
  }
}

