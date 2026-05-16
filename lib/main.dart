import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/game_provider.dart';
import 'core/services/ad_service.dart';
import 'presentation/screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initializeCosmicAds();
  
  final gameProvider = GameProvider();
  await gameProvider.loadGameSettings();

  runApp(
    ChangeNotifierProvider<GameProvider>.value(
      value: gameProvider,
      child: const GalaxiaMindApp(),
    ),
  );
}

class GalaxiaMindApp extends StatelessWidget {
  const GalaxiaMindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Galaxia Mind',
      debugShowCheckedModeBanner: false,
      home: MainMenuScreen(),
    );
  }
}

