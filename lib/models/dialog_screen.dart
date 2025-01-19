import 'package:flutter/material.dart';

class DialogScreen {
  final BuildContext context;
  final String title;
  final Widget body;
  final VoidCallback? onConfirmed;
  final List<BoxShadow>? buttonShadow; // Sombra personalizada para o botão OK.

  DialogScreen({
    required this.context,
    required this.title,
    required this.body,
    this.onConfirmed,
    this.buttonShadow,
  });

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar clicando fora do diálogo
      builder: (BuildContext context) {
        // Obter dimensões da tela
        final size = MediaQuery.of(context).size;
        final width = size.width;
        final height = size.height;

        return Stack(
          children: [
            Positioned(
              top: height * 0.06, // Ajuste de posição vertical
              left: width * 0.14, // Margem esquerda
              right: width * 0.14, // Margem direita
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.purple.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(width * 0.04),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(width * 0.04),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // AppBar-like Header
                      Container(
                        padding: EdgeInsets.symmetric(vertical: height * 0.01),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 201, 101, 247),
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      // Body Content
                      body,
                      SizedBox(height: height * 0.02),
                      // Actions
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: buttonShadow ?? [],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fecha o diálogo
                              if (onConfirmed != null) onConfirmed!(); // Executa ação de confirmação
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.01,
                              ),
                              backgroundColor: const Color.fromARGB(255, 223, 181, 255),
                              foregroundColor: const Color.fromARGB(255, 201, 101, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width * 0.06),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 224, 188, 252),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Text(
                              "OK",
                              style: TextStyle(fontSize: width * 0.035),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
