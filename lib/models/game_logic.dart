import 'package:flutter/material.dart';

class GameLogic {
  // Estado inicial do tabuleiro (vazio).
  final List<String> _board = List.generate(9, (_) => '');

  // Controle do jogador atual (X ou O).
  String _currentPlayer = 'X';

  // Callback para notificações de mudança de estado.
  VoidCallback? _onStateChanged;

  // Configura o callback para mudanças de estado.
  void setOnStateChanged(VoidCallback callback) {
    _onStateChanged = callback;
  }

  // Método chamado ao clicar em uma célula.
  void onCellTap(int index) {
    if (_board[index].isNotEmpty) return; // Impede sobreescrever células ocupadas.

    // Atualiza o estado da célula com o jogador atual.
    _board[index] = _currentPlayer;

    // Alterna entre X e O.
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';

    // Notifica a mudança de estado.
    _onStateChanged?.call();
  }

  // Retorna o estado da célula (X, O ou vazio).
  String getCellState(int index) {
    return _board[index];
  }

  // Retorna o jogador atual (X ou O).
  String getCurrentPlayer() {
    return _currentPlayer;
  }

  // Define a cor da célula com base no estado.
  Color getCellColor(int index) {
    if (_board[index] == 'X') {
      return Colors.red.shade100;
    } else if (_board[index] == 'O') {
      return Colors.blue.shade100;
    } else {
      return Colors.grey.shade100;
    }
  }

  // Verifica vitória em qualquer direção.
  bool checkVictory() {
    const winPatterns = [
      [0, 1, 2], // Linha superior
      [3, 4, 5], // Linha do meio
      [6, 7, 8], // Linha inferior
      [0, 3, 6], // Coluna esquerda
      [1, 4, 7], // Coluna do meio
      [2, 5, 8], // Coluna direita
      [0, 4, 8], // Diagonal principal
      [2, 4, 6], // Diagonal secundária
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] != '' &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[0]] == _board[pattern[2]]) {
        return true;
      }
    }
    return false;
  }

  // Verifica empate.
  bool checkDraw() {
    return _board.every((cell) => cell.isNotEmpty) && !checkVictory();
  }

  // Reseta o tabuleiro para um novo jogo.
  void resetBoard() {
    for (int i = 0; i < _board.length; i++) {
      _board[i] = '';
    }
    _currentPlayer = 'X';
    _onStateChanged?.call(); // Notifica a mudança de estado.
  }
}
