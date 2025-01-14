import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static double titleFontSize = 25;
  
  // Adiciona uma cor de fundo como propriedade
  static Color backgroundColor = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //////////////////////
      // BARRA DE TÍTULO
      //////////////////////
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

      //////////////////////
      // CORPO DO JOGO
      //////////////////////
      body: Container(
        // Usa a cor de fundo
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloco dos placares
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(
                  color: const Color.fromARGB(255, 202, 201, 201), 
                  width: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(66, 90, 90, 90),
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Placar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Seção do Jogador 1 (X - Vermelho)
                  PlayerSection(
                    icon: Icons.close, // Ícone X
                    labelName: "Nome do jogador 1",
                    score: 0,
                    iconColor: Colors.red,
                    backgroundColor: Colors.red.shade100,
                  ),
                  const SizedBox(height: 16),
                  // Seção do Jogador 2 (O - Azul)
                  PlayerSection(
                    icon: Icons.circle_outlined, // Ícone O
                    labelName: "Nome do jogador 2",
                    score: 0,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////
// WIDGET PlayerSection
//////////////////////
class PlayerSection extends StatelessWidget {
  final IconData icon;
  final String labelName;
  final int score;
  final Color iconColor;
  final Color backgroundColor;

  const PlayerSection({
    super.key,
    required this.icon,
    required this.labelName,
    required this.score,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ícone do Jogador
        Icon(
          icon,
          size: 32,
          color: iconColor,
        ),
        const SizedBox(width: 8),

        // Nome do jogador e TextField
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: labelName,
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(
                text: labelName == "Nome do jogador 1"
                    ? "Jogador 1"
                    : "Jogador 2"),
          ),
        ),
        const SizedBox(width: 8),

        // Bloco do Placar
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }
}
