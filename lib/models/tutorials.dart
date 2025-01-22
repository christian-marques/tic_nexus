import 'package:flutter/material.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromARGB(104, 148, 15, 182), // Fundo translúcido
      child: Center(
        child: SingleChildScrollView( // Adicionado para permitir rolagem
          child: Stack(
            children: [
              Container(
                width: screenWidth * 0.99,
                height: screenHeight * 0.46,
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
                          margin: EdgeInsets.only(top: screenHeight * 0.001),
                          height: 0.9,
                          width: screenWidth * 0.7,
                          color: const Color.fromARGB(255, 186, 104, 200), // Cor lilás
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Corpo do tutorial
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: screenWidth * 0.037,
                          color: Colors.black54,
                          height: 1.0, // Espaçamento entre linhas
                        ),
                        children: [
                          // Parágrafo inicial com recuo na primeira linha
                          TextSpan(
                            text: "Neste jogo, você pode aprimorar suas habilidades de lógica de maneira divertida e nostálgica com uma nova versão do clássico jogo da velha.\n\n",
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: Colors.black54,
                              height: 1.0,
                            ),
                            recognizer: null,
                          ),
                          // Tópicos
                          TextSpan(
                            text: "• Para começar, escolha os nomes dos jogadores que representarão o 'X' e o 'O'.\n\n",
                          ),
                          TextSpan(
                            text: "• Em seguida, clique em 'Start' para iniciar a partida.\n\n",
                          ),
                          TextSpan(
                            text: "• Caso queira reiniciar, clique em 'Reset' para redefinir os nomes, limpar o tabuleiro e zerar o placar.\n\n",
                          ),
                          TextSpan(
                            text: "• Você também pode alternar entre o modo jogador contra jogador ou jogador contra a máquina clicando no botão no canto superior direito.\n\n",
                          ),
                          // Encerramento
                          TextSpan(
                            text: "Divirta-se e aproveite a experiência!\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "Atenciosamente,\ncmos.",
                          ),
                        ],
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
