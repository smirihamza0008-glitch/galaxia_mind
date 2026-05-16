import 'package:flutter/material.dart';

class AdService {
  static bool _isSystemInitialized = false;
  static bool _isWormholeAdReady = false;
  static bool _isQuantumRewardReady = false;

  static Future<void> initializeCosmicAds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isSystemInitialized = true;
    _preloadCosmicChannels();
  }

  static void _preloadCosmicChannels() {
    if (!_isSystemInitialized) return;
    _isWormholeAdReady = true;
    _isQuantumRewardReady = true;
  }

  static Future<bool> triggerQuantumRewardAd(BuildContext context) async {
    bool rewardGranted = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1135),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.satellite_alt, color: Color(0xFFFFD700), size: 28),
            SizedBox(width: 10),
            Text(
              'Signal Connection',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_tethering, color: Color(0xFF00E5FF), size: 55),
            SizedBox(height: 18),
            Text(
              'Connect to the satellite signal to unlock the next hint instantly.',
              textAlign: Center,
              style: TextStyle(color: Color(0xFF7E8A9A), fontSize: 14, height: 1.5),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  rewardGranted = false;
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                ),
                onPressed: () {
                  rewardGranted = true;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Watch Ad',
                  style: TextStyle(color: Color(0xFF080710), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return rewardGranted;
  }

  static Future<void> launchWormholeInterstitial(BuildContext context) async {
    if (_isWormholeAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.all_inclusive, color: Color(0xFF00E5FF)),
              SizedBox(width: 12),
              Text('Loading next galaxy...'),
            ],
          ),
          backgroundColor: Color(0xFF0F1B35),
          duration: Duration(seconds: 2),
        ),
      );
      _preloadCosmicChannels();
    }
  }
}
