import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String imageName; // Nome da imagem, sem o caminho completo
  final double height;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.imageName,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        'assets/images/$imageName', // Caminho completo montado automaticamente
        height: height,
      ),
    );
  }
}
