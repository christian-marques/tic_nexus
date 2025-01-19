import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final List<PlayerSection> players;

  const ScoreBoard({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.02), // Espaçamento proporcional
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
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
          SizedBox(height: screenHeight * 0.02), // Espaçamento proporcional
          ...players,
        ],
      ),
    );
  }
}

class PlayerSection extends StatelessWidget {
  final IconData icon;
  final String labelName;
  final String initialName;
  final int score;
  final Color iconColor;
  final Color backgroundColor;
  final ValueChanged<String>? onNameChanged; // Callback para mudanças no nome do jogador

  const PlayerSection({
    super.key,
    required this.icon,
    required this.labelName,
    required this.initialName,
    required this.score,
    required this.iconColor,
    required this.backgroundColor,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController controller = TextEditingController(text: initialName);

    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02), // Espaçamento proporcional
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícone do Jogador
          Icon(
            icon,
            size: screenWidth * 0.08, // Tamanho proporcional ao dispositivo
            color: iconColor,
          ),
          SizedBox(width: screenWidth * 0.02),

          // Nome do jogador e TextField
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelName,
                border: OutlineInputBorder(),
              ),
              onSubmitted: onNameChanged, // Chama o callback ao finalizar a edição
            ),
          ),
          SizedBox(width: screenWidth * 0.015),

          // Bloco do Placar
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score.toString(),
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
