import 'package:flutter/material.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromARGB(132, 0, 0, 0), // Fundo translúcido
      child: Center(
        child: Container(
          width: screenWidth * 1.1,
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(2, 2),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: const Color.fromARGB(255, 186, 104, 200), // Cor lilás
                width: 1.0,
              ),
              right: BorderSide(
                color: const Color.fromARGB(255, 186, 104, 200),
                width: 1.0,
              ),
              left: BorderSide(
                color: const Color.fromARGB(255, 186, 104, 200),
                width: 1.0,
              ),
              bottom: BorderSide(
                color: const Color.fromARGB(255, 186, 104, 200),
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título com linha inferior lilás
              Column(
                children: [
                  Text(
                    "Bem vindo ao Tic Nexus!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.01),
                    height: 0.7,
                    width: screenWidth * 0.7,
                    color: const Color.fromARGB(255, 186, 104, 200), // Cor lilás
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              // Corpo do tutorial
              Text(
                """
Nesse jogo você desenvolve suas habilidades de lógica de uma maneira diferenciada e nostálgica: jogando a nova versão do jogo da velha.
Primeiro, escolha os nomes de quem vai ser o 'X' e o 'O' e, após, é só apertar em 'Start' e começar a jogar.
Caso deseje finalizar a partida, clique em 'Reset' para apagar o nome dos jogadores, limpar o tabuleiro e zerar o placar.
Bom jogo!

sds, cmos.
                """,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
