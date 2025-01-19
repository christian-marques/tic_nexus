import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final List<PlayerSection> players;

  const ScoreBoard({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    final TextEditingController controller = TextEditingController(text: initialName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
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
              controller: controller,
              decoration: InputDecoration(
                labelText: labelName,
                border: OutlineInputBorder(),
              ),
              onSubmitted: onNameChanged, // Chama o callback ao finalizar a edição
              // onEditingComplete: onNameChanged,
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
      ),
    );
  }
}
