import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tic_nexus/pages/game.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // Redireciona mensagens do sistema para um "sink" vazio.
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.contains(">>>")) {
      log(message, name: "DEVELOPER"); // Exibe apenas seus logs.
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o ícone de "DEBBUG"
      home: GamePage()
    );
  }
}