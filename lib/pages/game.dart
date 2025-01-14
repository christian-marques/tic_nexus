import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static double TITLE_SIZE = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TIC NEXUS", 
          style: TextStyle(
            fontSize: TITLE_SIZE
          )
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: (TITLE_SIZE+5),
      ),

    );
  }
}