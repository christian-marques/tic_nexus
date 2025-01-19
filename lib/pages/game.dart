// import 'dart:developer';
import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:tic_nexus/models/dialog_screen.dart';
import 'package:tic_nexus/models/icon_button.dart';
import 'package:tic_nexus/models/score_board.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_nexus/models/game_table.dart';
import 'package:tic_nexus/models/game_logic.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final AdHelper _adHelper = AdHelper();
  final GameLogic _gameLogic = GameLogic();
  BannerAd? _bannerAd;

  static int scoreX = 0;
  static int scoreO = 0;
  static String nameX = 'Jogador X'; 
  static String nameO = 'Jogador O'; 

  @override
  void initState() {
    super.initState();

    _adHelper.loadBannerAd((banner) {
      setState(() {
        _bannerAd = banner;
      });
    });

    _adHelper.loadInterstitialAd((interstitial) {
      setState(() {});
    });

    _gameLogic.onWinnerDeclared = (winnerSymbol) {
      String winnerName = '';
      setState(() {
        if (winnerSymbol == "X") {
          scoreX++;
          winnerName = nameX;
        } else if (winnerSymbol == "O") {
          scoreO++;
          winnerName = nameO;
        }
      });
      _showWinnerDialog(winnerSymbol, winnerName);
    };
  }

  @override
  void dispose() {
    _adHelper.disposeAds();
    super.dispose();
  }

  void _resetBoard() {
    setState(() {
      _gameLogic.resetBoard();
    });
  }

  void _resetGame() {
    _resetBoard();
    scoreX = 0;
    scoreO = 0;
    nameX = "Jogador X";
    nameO = "Jogador O";
  }

  void _showAdsense() {
    _adHelper.showInterstitialAd();
  }

// MENSAGENS:
// -------------------------------
//  1) Caso empate:
//      __"Empate!"__
//      "Jogador X e Jogador O,"
//      "jogaram muito bem!"
// -------------------------------
//  2) Caso Vitória X:
//      __"Parabéns, Jogador X!"__
//      "O <icone X> venceu!"
// -------------------------------
//  3) Caso Vitória O:
//      __"Parabéns, Jogador O!"__
//      "O <icone O> venceu!"
// -------------------------------
void _showWinnerDialog(String winnerSymbol, String winnerName) {
  final Widget body = RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: const TextStyle(fontSize: 18.0, color: Colors.black),
      children: winnerSymbol == '-'
          ? [
              TextSpan(
                text: "$nameX e $nameO,\n",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: "jogaram muito bem!"),
            ]
          : [
              const TextSpan(text: "O "),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  winnerSymbol == 'X' ? Icons.close : Icons.circle_outlined,
                  size: 24, // Funciona como um "tamanho de fonte" para o ícone no meio do texto
                  color: winnerSymbol == 'X' ? Colors.red : Colors.blue,
                ),
              ),
              const TextSpan(text: " venceu!"),
            ],
    ),
  );

  DialogScreen(
    context: context,
    title: winnerSymbol == '-' ? "Empate!" : "Parabéns, $winnerName!",
    body: body,
    onConfirmed: _resetBoard, // Reseta o tabuleiro ao confirmar
  ).show();
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "TIC NEXUS",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: screenHeight * 0.04,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Placar
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.002, horizontal: screenWidth * 0.001),
            child: ScoreBoard(
              players: [
                PlayerSection(
                  icon: Icons.close,
                  labelName: "Jogador X",
                  initialName: nameX,
                  score: scoreX,
                  iconColor: Colors.red,
                  backgroundColor: const Color(0xFFFFCDD2),
                  onNameChanged: (newName) {
                    setState(() {
                      nameX = newName;
                    });
                  },
                ),
                PlayerSection(
                  icon: Icons.circle_outlined,
                  labelName: "Jogador O",
                  initialName: nameO,
                  score: scoreO,
                  iconColor: Colors.blue,
                  backgroundColor: const Color(0xFFBBDEFB),
                  onNameChanged: (newName) {
                    setState(() {
                      nameO = newName;
                    });
                  },
                ),
              ],
            ),
          ),

          // Tabuleiro
          Expanded(
            child: GameTable(gameLogic: _gameLogic),
          ),

          // Botões
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10, vertical: screenHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  imageName: 'start.png',
                  width: screenWidth * 0.27,
                  onPressed: _resetBoard,
                ),
                CustomIconButton(
                  imageName: 'adsense.png',
                  width: screenWidth * 0.16,
                  onPressed: _showAdsense,
                ),
                CustomIconButton(
                  imageName: 'reset.png',
                  width: screenWidth * 0.27,
                  onPressed: _resetGame,
                ),
              ],
            ),
          ),

          // Banner Ad
          if (_bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!)
            ),
        ],
      ),
    );
  }
}
