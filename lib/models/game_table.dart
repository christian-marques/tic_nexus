import 'package:flutter/material.dart';
import 'package:tic_nexus/models/game_logic.dart';

class GameTable extends StatefulWidget {
  final GameLogic gameLogic;

  const GameTable({super.key, required this.gameLogic});

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  @override
  void initState() {
    super.initState();
    widget.gameLogic.setOnStateChanged(() {
      setState(() {}); // Atualiza a interface ao alterar o estado.
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = screenWidth / 3.2; // Calcula tamanho da célula relativo à largura da tela.

    return Center(
      child: SizedBox(
        width: cellSize * 3, // Largura do tabuleiro (3 células por linha).
        height: cellSize * 3, // Altura do tabuleiro (3 células por coluna).
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Tabuleiro 3x3.
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
          ),
          itemCount: 9, // 9 células.
          itemBuilder: (context, index) {
            final cellState = widget.gameLogic.getCellState(index);
            final cellColor = widget.gameLogic.getCellColor(index); // Obtém a cor da célula.

            return GestureDetector(
              onTap: () {
                widget.gameLogic.onCellTap(index); // Atualiza lógica ao tocar.
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cellColor, // Cor de fundo da célula baseada no estado.
                  border: Border.all(color: Colors.grey.shade300, width: 1.0), // Linha cinza clara.
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? Radius.circular(8.0) : Radius.zero,
                    topRight: index == 2 ? Radius.circular(8.0) : Radius.zero,
                    bottomLeft: index == 6 ? Radius.circular(8.0) : Radius.zero,
                    bottomRight: index == 8 ? Radius.circular(8.0) : Radius.zero,
                  ),
                ),
                alignment: Alignment.center,
                child: cellState.isEmpty
                    ? null
                    : Icon(
                        cellState == 'X' ? Icons.close : Icons.circle_outlined,
                        size: cellSize * 0.6, // Ícone proporcional ao tamanho da célula.
                        color: cellState == 'X' ? Colors.red : Colors.blue,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
