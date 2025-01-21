import 'dart:math';

class CPUPlayer {
  final Random _random = Random();

  /// Retorna uma posição aleatória válida para o próximo movimento da CPU.
  /// [board] é o estado atual do tabuleiro, com "" indicando posições vazias.
  int getNextMove(List<String> board) {
    // Filtra as posições disponíveis (vazias)
    List<int> availablePositions = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        availablePositions.add(i);
      }
    }

    // Retorna uma posição aleatória entre as disponíveis
    if (availablePositions.isNotEmpty) {
      return availablePositions[_random.nextInt(availablePositions.length)];
    }

    // Caso todas as posições estejam ocupadas (não deveria ocorrer)
    return -1;
  }
}