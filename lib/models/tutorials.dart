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
        child: Stack(
          children: [
            Container(
              width: screenWidth * 0.99,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(2, 2),
                  ),
                ],
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

            // Arcos nos cantos
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: Size(screenWidth * 0.2, screenWidth * 0.2),
                painter: CornerArcPainter(
                  color: const Color.fromARGB(255, 186, 104, 200),
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: Size(screenWidth * 0.2, screenWidth * 0.2),
                painter: CornerArcPainter(
                  color: const Color.fromARGB(255, 186, 104, 200),
                  alignment: Alignment.topRight,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: CustomPaint(
                size: Size(screenWidth * 0.2, screenWidth * 0.2),
                painter: CornerArcPainter(
                  color: const Color.fromARGB(255, 186, 104, 200),
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomPaint(
                size: Size(screenWidth * 0.2, screenWidth * 0.2),
                painter: CornerArcPainter(
                  color: const Color.fromARGB(255, 186, 104, 200),
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CornerArcPainter extends CustomPainter {
  final Color color;
  final Alignment alignment;

  CornerArcPainter({required this.color, required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = alignment == Alignment.topLeft
        ? 3.14
        : alignment == Alignment.topRight
            ? 1.5 * 3.14
            : alignment == Alignment.bottomLeft
                ? 0.5 * 3.14
                : 0.0;

    canvas.drawArc(rect, startAngle, 0.5 * 3.14, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
