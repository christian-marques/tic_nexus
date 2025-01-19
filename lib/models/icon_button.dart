import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String imageName; // Nome da imagem, sem o caminho completo
  final double width;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.imageName,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        'assets/images/$imageName', // Caminho completo montado automaticamente
        width: width,
      ),
    );
  }
}
