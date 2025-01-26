import 'dart:developer';
import 'package:tic_nexus/models/cpu_player.dart';
import 'package:flutter/material.dart';

class GameLogic {
  final List<String> _board = List.generate(9, (_) => ''); // Estado inicial do tabuleiro (vazio).
  final CPUPlayer _cpuPlayer = CPUPlayer(); // Adicione a instância do CPUPlayer
  static bool _isGameRunning = false;
  static bool _isCpuPlayer = false;
  static bool _isProcessing = false; // Indica se uma jogada está sendo processada
  var _isStartTimeX = true;


  // Controle do jogador atual (X ou O).
  String _currentPlayer = 'X';

  // Callback para notificações de mudança de estado.
  VoidCallback? _onStateChanged;

  // Callback para notificar vitória ou empate.
  Function(String)? onWinnerDeclared;

  // Configura o estado do jogo como iniciado.
  void startGame() {
    _isGameRunning = true;
    log("Jogo iniciado", name: "GAME_LOGIC");
  }

  // Configura o estado do jogo como finalizado.
  void finishGame() {
    _isGameRunning = false;
    log("Jogo finalizado", name: "GAME_LOGIC");
  }

  // Verifica se o jogo está em andamento.
  bool isGameRunning() {
    return _isGameRunning;
  }

  // Coloca o Jogador O como CPU
  void setPlayerOasCPU(){
    _isCpuPlayer = true;
  }

  // Coloca o Jogador O como humano
  void setPlayerOasHuman(){
    _isCpuPlayer = false;
  }

  bool isPlayerOCPU(){
    return _isCpuPlayer;
  }

  // Configura o callback para mudanças de estado.
  void setOnStateChanged(VoidCallback callback) {
    _onStateChanged = callback;
  }

  // Configura o callback para notificações de vitória ou empate.
  void setOnWinnerDeclared(Function(String) callback) {
    onWinnerDeclared = callback;
  }

  // Método chamado ao clicar em uma célula.
  void onCellTap(int index) {
    if (_isProcessing) {
      log("Jogada em processamento. Aguarde!", name: "GAME_LOGIC");
      return;
    }

    if (!_isGameRunning) {
      log("Tentativa de jogar sem o jogo iniciado", name: "GAME_LOGIC");
      return; // Bloqueia jogadas sem iniciar o jogo
    }
    if (_board[index].isNotEmpty) {
      log("Tentativa de sobreposição de jogada", name: "GAME_LOGIC");
      return; // Bloqueia sobreposição de jogadas
    }

    // Atualiza o estado da célula com o jogador atual.
    _board[index] = _currentPlayer;

    // Verifica se há vitória ou empate após o movimento.
    if (checkVictory()) {
      finishGame();
      onWinnerDeclared?.call(_currentPlayer); // Notifica o jogador vencedor.
    } else if (checkDraw()) {
      finishGame();
      onWinnerDeclared?.call('-'); // Notifica empate.
      return;
    }

    // Alterna entre X e O.
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';

    // Jogada da CPU (apenas se for a vez da "O" e isPlayerOCPU for true)
    if (_currentPlayer == 'O' && isPlayerOCPU()) {
      _isProcessing = true; // Bloqueia jogadas enquanto a CPU processa
      int cpuMove = _cpuPlayer.getNextMove(_board);
      if (cpuMove != -1) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _isProcessing = false; // Libera após a jogada
          onCellTap(cpuMove); // Chama recursivamente para validar e executar a jogada
        });
      }
      else{
        _isProcessing = false; // Libera após a jogada humanda
      }
    }

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
        log(">>>>>>>>>> VITÓRIAAAA!!", name: "GAME_LOGIC");
        return true;
      }
    }
    return false;
  }

  // Verifica empate.
  bool checkDraw() {
    if (_board.every((cell) => cell.isNotEmpty) && !checkVictory()) {
      log(">>>>>>>>>> EMPATE!!", name: "GAME_LOGIC");
      return true;
    }
    return false;
  }

  // Reseta o tabuleiro para um novo jogo.
  void resetBoard() {
    for (int i = 0; i < _board.length; i++) {
      _board[i] = '';
    }
    _isStartTimeX = !_isStartTimeX;
    _currentPlayer = _isStartTimeX ? 'X' : 'O';
    _isProcessing = false; // Garante que não tem
    log("Tabuleiro resetado", name: "GAME_LOGIC");
  }
}
