import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'dart:math';

class GameLogic2 {
  final List<List<String>> _miniBoards = List.generate(9, (_) => List.generate(9, (_) => ''));
  final List<String> _mainBoard = List.generate(9, (_) => '');
  int _clickMovimentGame = 0;

  String _currentPlayer = 'X';
  int? _nextMiniBoard;
  bool _isGameRunning = false;
  bool _isPlayerOCPU = false;
  bool _isProcessing = false;

  VoidCallback? _onStateChanged;
  Function(String)? onWinnerDeclared;
  Function(int boardIndex, int cellIndex)? onCellPlayed;


  // Configura o estado do jogo como iniciado
  void startGame() {
    _isGameRunning = true;
    developer.log("Jogo 2.0 iniciado", name: "GAME_LOGIC_2");
  }

  // Configura o estado do jogo como finalizado
  void finishGame() {
    _isGameRunning = false;
    developer.log("Jogo 2.0 finalizado", name: "GAME_LOGIC_2");
  }

  // Verifica se o jogo está em andamento
  bool isGameRunning() => _isGameRunning;

  // Define o Jogador O como CPU
  void setPlayerOasCPU() {
    developer.log("setPlayerOasCPU", name: "GAME_LOGIC_2");
    _isPlayerOCPU = true;
  }

  // Define o Jogador O como humano
  void setPlayerOasHuman() {
    developer.log("setPlayerOasHuman", name: "GAME_LOGIC_2");
    _isPlayerOCPU = false;
  }

  // Configura o callback para mudanças de estado
  void setOnStateChanged(VoidCallback callback) {
    _onStateChanged = callback;
  }

  // Configura o callback para notificações de vitória ou empate
  void setOnWinnerDeclared(Function(String) callback) {
    onWinnerDeclared = callback;
  }

  // Retorna o estado de uma célula específica de um mini tabuleiro
  String getMiniCellState(int boardIndex, int cellIndex) {
    return _miniBoards[boardIndex][cellIndex];
  }

  // Retorna o estado do mini tabuleiro no tabuleiro principal
  String getMainBoardState(int boardIndex) {
    return _mainBoard[boardIndex];
  }

  String getCurrentPlayer() {
    return _currentPlayer;
  }

  int getClickMovimentGame(){
    return _clickMovimentGame;
  }

  // Reseta o tabuleiro para um novo jogo
  void resetBoard() {
    for (var i = 0; i < 9; i++) {
      _miniBoards[i] = List.generate(9, (_) => '');
      _mainBoard[i] = '';
    }
    _nextMiniBoard = null;
    _currentPlayer = 'X';
    _isProcessing = false;
    _isGameRunning = false;
    _onStateChanged?.call();
    _clickMovimentGame = 0;
    developer.log("Tabuleiros resetados", name: "GAME_LOGIC_2");
  }

  // Lógica de movimento
  void makeMove(int boardIndex, int cellIndex) {
    if (_isProcessing && !_isPlayerOCPU) {
      developer.log("Jogada em processamento. Aguarde!", name: "GAME_LOGIC_2");
      return;
    }

    if (!_isGameRunning) {
      developer.log("Tentativa de jogar sem iniciar o jogo", name: "GAME_LOGIC_2");
      return;
    }

    if (_miniBoards[boardIndex][cellIndex] != '' || !_isMiniBoardAvailable(boardIndex)) {
      developer.log("Movimento inválido no tabuleiro $boardIndex, célula $cellIndex", name: "GAME_LOGIC_2");
      return;
    }

    _miniBoards[boardIndex][cellIndex] = _currentPlayer;

    // Chamar callback para notificar a interface
    onCellPlayed?.call(boardIndex, cellIndex);

    // Incrementa o contador de movimentos no tabuleiro
    _clickMovimentGame++;
    developer.log("Clicks: $_clickMovimentGame", name: "GAME_LOGIC_2");

    if (_checkMiniBoardVictory(boardIndex)) {
      if (_checkMainBoardVictory()) {
        finishGame();
        onWinnerDeclared?.call(_currentPlayer); // Declara vencedor
        return;
      } else if (_checkMainBoardDraw()) {
        finishGame();
        onWinnerDeclared?.call('-'); // Notifica empate.
        return;
      }
    } else if (_checkMiniBoardDraw(boardIndex)) {
      if (_checkMainBoardVictory()) {
        finishGame();
        onWinnerDeclared?.call('-'); // Declara empate no tabuleiro principal
        return;
      } else if (_checkMainBoardDraw()) {
        finishGame();
        onWinnerDeclared?.call('-'); // Notifica empate.
        return;
      }
    }

    _nextMiniBoard = cellIndex;
    _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';

    if (_currentPlayer == 'O' && _isPlayerOCPU) {
      developer.log("Vai entrar no CPU", name: "GAME_LOGIC_2");
      _cpuMove();
      _isProcessing = true; // Bloqueia novas jogadas enquanto a CPU processa
    }
    _onStateChanged?.call();
  }



  void _cpuMove() {
    if (!_isGameRunning || !_isPlayerOCPU) return;

    List<int> availableBoards = getAvailableMiniBoards();
    if (availableBoards.isEmpty) return;

    // Seleciona um mini tabuleiro aleatório entre os disponíveis
    int boardIndex = availableBoards[Random().nextInt(availableBoards.length)];

    developer.log("Tabuleiros dispiníveis: '$availableBoards' | Tabuleiro escolhido: '$boardIndex'", name: "GAME_LOGIC_2");

    // Seleciona uma célula aleatória dentro do mini tabuleiro escolhido
    List<int> availableCells = [];
    for (int i = 0; i < 9; i++) {
      if (_miniBoards[boardIndex][i] == '') {
        availableCells.add(i);
      }
    }

    if (availableCells.isNotEmpty) {
      int cellIndex = availableCells[Random().nextInt(availableCells.length)];
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (_isGameRunning && _isPlayerOCPU) {
          developer.log("Células dispiníveis: '$availableCells' | Célula escolhida: '$cellIndex'", name: "GAME_LOGIC_2");
          // Notificar a interface sobre a jogada da CPU
          onCellPlayed?.call(boardIndex, cellIndex);
          makeMove(boardIndex, cellIndex);
        }
        _isProcessing = false; // Libera o estado após a jogada

        // Adiciona o delay após a execução do bloco acima
        Future.delayed(const Duration(milliseconds: 500), () {
          developer.log("Delay adicional após a jogada da CPU.", name: "GAME_LOGIC_2");
        });
      });
    }
  }


  // Verifica se o mini tabuleiro está disponível
  bool _isMiniBoardAvailable(int boardIndex) {
    return getAvailableMiniBoards().contains(boardIndex);
  }

  // Retorna os índices dos mini tabuleiros disponíveis para jogar
  List<int> getAvailableMiniBoards() {
    if (_nextMiniBoard == null || _mainBoard[_nextMiniBoard!] != '') {
      return List.generate(9, (index) => index).where((i) => _mainBoard[i] == '').toList();
    }
    return [_nextMiniBoard!];
  }

  // Verifica vitória em um mini tabuleiro
  bool _checkMiniBoardVictory(int boardIndex) {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (_miniBoards[boardIndex][pattern[0]] != '' &&
          _miniBoards[boardIndex][pattern[0]] == _miniBoards[boardIndex][pattern[1]] &&
          _miniBoards[boardIndex][pattern[1]] == _miniBoards[boardIndex][pattern[2]]) {
        _mainBoard[boardIndex] = _miniBoards[boardIndex][pattern[0]];
        developer.log("[Vitória] Icone de finalização do mini tabuleiro: '${_mainBoard[boardIndex]}'", name: "GAME_LOGIC_2");
        return true;
      }
    }
    return false;
  }

  // Verifica empate em um mini tabuleiro
  bool _checkMiniBoardDraw(int boardIndex) {
    if (_miniBoards[boardIndex].every((cell) => cell != '') && !_checkMiniBoardVictory(boardIndex)) {
      // Atualiza o estado no tabuleiro principal como empate
      _mainBoard[boardIndex] = '-';
      developer.log("[Empate] Icone de finalização do mini tabuleiro: '${_mainBoard[boardIndex]}'", name: "GAME_LOGIC_2");
      return true;
    }
    return false;
  }


  // Verifica empate no tabuleiro principal
  bool _checkMainBoardDraw() {
    List<int> availableBoards = getAvailableMiniBoards();
    developer.log("[Empate total] Mini tabuleiros disponíveis: '$availableBoards'", name: "GAME_LOGIC_2");
    if (availableBoards.isEmpty){
      developer.log("[Empate total] Jogo principal empatou: ", name: "GAME_LOGIC_2");
      return true;
    }
    return false;
  }


  // Verifica vitória no tabuleiro principal
  bool _checkMainBoardVictory() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (_mainBoard[pattern[0]] != '' &&
          _mainBoard[pattern[0]] == _mainBoard[pattern[1]] &&
          _mainBoard[pattern[1]] == _mainBoard[pattern[2]]) {
        return true;
      }
    }
    return false;
  }
}
