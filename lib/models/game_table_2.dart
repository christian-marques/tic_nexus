import 'package:flutter/material.dart';
import 'package:tic_nexus/models/game_logic_2.dart';

class GameTable2 extends StatefulWidget {
  final GameLogic2 gameLogic2;

  const GameTable2({super.key, required this.gameLogic2});

  @override
  State<GameTable2> createState() => _GameTable2State();
}

class _GameTable2State extends State<GameTable2> {
  @override
  void initState() {
    super.initState();
    widget.gameLogic2.setOnStateChanged(() {
      setState(() {}); // Atualiza a interface ao alterar o estado.
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = screenWidth / 10; // Ajuste para mini tabuleiros

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            final boardIndex = row * 3 + col; // Índice do mini tabuleiro
            final isAvailable = widget.gameLogic2.getAvailableMiniBoards().contains(boardIndex);
            final mainBoardState = widget.gameLogic2.getMainBoardState(boardIndex); // MOVIDO PARA FORA

            return Container(
              width: cellSize * 3,
              height: cellSize * 3,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isAvailable
                    ? (widget.gameLogic2.getCurrentPlayer() == 'X'
                        ? const Color.fromARGB(50, 244, 67, 54) // Cor vermelha com opacidade para "X"
                        : const Color.fromARGB(50, 33, 149, 243)) // Cor azul com opacidade para "O"
                    : Colors.grey.shade300, // Cor para tabuleiros indisponíveis
                border: Border.all(
                  color: isAvailable
                    ? (widget.gameLogic2.getCurrentPlayer() == 'X'
                        ? const Color.fromARGB(150, 244, 67, 54) // Cor vermelha com opacidade para "X"
                        : const Color.fromARGB(150, 33, 149, 243)) // Cor azul com opacidade para "O"
                    : Colors.grey.shade300, // Cor para tabuleiros indisponíveis
                  width: isAvailable ? 1.8 : 1.0,
                ),
              ),
              child: Stack(
                children: [

                  // Mini tabuleiro (células)
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3x3 células em cada mini tabuleiro
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, cellIndex) {
                      final cellState = widget.gameLogic2.getMiniCellState(boardIndex, cellIndex);

                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                                widget.gameLogic2.makeMove(boardIndex, cellIndex);
                              }
                            : null, // Bloqueia interações em mini tabuleiros não disponíveis
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 0.01),
                          ),
                          child: Text(
                            cellState,
                            style: TextStyle(
                              fontSize: cellSize * 0.6,
                              fontWeight: FontWeight.bold,
                              color: cellState == 'X'
                                  ? Colors.red
                                  : cellState == 'O'
                                      ? Colors.blue
                                      : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Camada translúcida para o próximo jogador (fica na frente das células)
                  if (isAvailable)
                    Positioned.fill(
                      child: IgnorePointer( // Permite cliques passarem para as células
                        ignoring: true,
                        child: Container(
                          color: widget.gameLogic2.getCurrentPlayer() == 'X'
                            ? const Color.fromARGB(45, 253, 0, 0) // Camada vermelha translúcida para X
                            : const Color.fromARGB(80, 2, 141, 255), // Camada azul translúcida para O
                        ),
                      ),
                    ),

                  // Sobreposição do mini tabuleiro quando finalizado
                  if (mainBoardState != '') // Verifica se o mini tabuleiro foi finalizado
                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                        child: Icon(
                          mainBoardState == '-'
                              ? Icons.remove // Ícone de empate
                              : mainBoardState == 'X'
                                  ? Icons.close // Ícone de vitória do X
                                  : Icons.circle_outlined, // Ícone de vitória do O
                          size: cellSize * 2.5, // Ícone grande
                          color: mainBoardState == '-'
                              ? Colors.grey // Ícone cinza para empate
                              : mainBoardState == 'X'
                                  ? Colors.red // Ícone vermelho para X
                                  : Colors.blue, // Ícone azul para O
                        ),
                      ),
                    ),

                ],
              ),
            );



            
          }),
        );
      }),
    );
  }
}
