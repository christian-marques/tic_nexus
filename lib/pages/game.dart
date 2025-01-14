import 'package:flutter/material.dart';
import 'package:tic_nexus/models/score_board.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static double titleFontSize = 25;
  static Color backgroundColor = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TIC NEXUS",
          style: TextStyle(fontSize: titleFontSize),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: (titleFontSize + 5),
      ),

      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloco do placar
            ScoreBoard(
              players: [
                PlayerSection(
                  icon: Icons.close,
                  labelName: "Nome do jogador 1",
                  initialName: "Jogador 1",
                  score: 0,
                  iconColor: Colors.red,
                  backgroundColor: const Color(0xFFFFCDD2), // Aproximado de Colors.redAccent.shade100
                ),
                PlayerSection(
                  icon: Icons.circle_outlined,
                  labelName: "Nome do jogador 2",
                  initialName: "Jogador 2",
                  score: 0,
                  iconColor: Colors.blue,
                  backgroundColor: const Color(0xFFBBDEFB), // Aproximado de Colors.blueAccent.shade100
                ),
              ],
            ),
          

          ],
        ),
      ),
    );
  }
}
