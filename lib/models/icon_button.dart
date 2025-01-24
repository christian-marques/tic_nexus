import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String imageName; // Nome da imagem, sem o caminho completo
  final double width;
  final VoidCallback onPressed;
  final bool isGameRunning;

  const CustomIconButton({
    super.key,
    required this.imageName,
    required this.width,
    required this.onPressed,
    required this.isGameRunning,
  });

  double _buttonOpacity() {
    const double hideOpacity = 0.2; 
    if (imageName == 'start.png') {
      return isGameRunning ? hideOpacity : 1.0;
    } else if (imageName == 'reset.png') {
      return isGameRunning ? 1.0 : hideOpacity;
    } else if (isGameRunning && ((imageName == 'player_vs_player.png') || (imageName == 'player_vs_cpu.png'))){
      return hideOpacity;
    }else if (isGameRunning && ((imageName == 'game_1.0.png') || (imageName == 'game_2.0.png'))){
      return hideOpacity;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _buttonOpacity(),
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          'assets/images/$imageName', // Caminho completo montado automaticamente
          width: width,
        ),
      ),
    );
  }
}
