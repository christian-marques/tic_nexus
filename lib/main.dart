import 'package:flutter/material.dart';
import 'package:tic_nexus/pages/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o ícone de "DEBBUG"
      home: const GamePage()
    );
  }
}