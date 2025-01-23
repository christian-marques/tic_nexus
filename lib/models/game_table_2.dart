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

            return Container(
              width: cellSize * 3,
              height: cellSize * 3,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.blue.shade100 : Colors.grey.shade300,
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Evita rolagem dentro dos mini tabuleiros
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
                        color: cellState == 'X'
                            ? Colors.red.shade100
                            : cellState == 'O'
                                ? Colors.blue.shade100
                                : Colors.white,
                        border: Border.all(color: Colors.black, width: 0.5),
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
            );
          }),
        );
      }),
    );
  }
}
