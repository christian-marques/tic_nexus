import 'dart:developer';

import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
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

    // Carregar Banner Ad
    _adHelper.loadBannerAd((banner) {
      setState(() {
        _bannerAd = banner;
      });
    });

    // Carregar Interstitial Ad
    _adHelper.loadInterstitialAd((interstitial) {
      setState(() {}); // Atualiza o estado para habilitar o botão
    });

    _gameLogic.onWinnerDeclared = (winnerSymbol) {
      String winnerName = '';
      setState(() {
        log(">>>>>>> O VENCEDOR FOI: '$winnerSymbol'", name: "DEVELOPER");
        if (winnerSymbol == "X"){
          scoreX++;
          winnerName = nameX;
          log(">>>>>>> Score X: '$scoreX'", name: "DEVELOPER");
        }
        else if (winnerSymbol == "O"){
          scoreO++;
          winnerName = nameO;
          log(">>>>>>> Score O: '$scoreO'", name: "DEVELOPER");
        }
      });
      // Exibe o diálogo após atualização
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
      _gameLogic.resetBoard(); // Apenas reseta o tabuleiro.
    });
  }

  void _resetGame(){
    _resetBoard();
    scoreX = 0;
    scoreO = 0;
    nameX = "Jogador X";
    nameO = "Jogador O";
  }

  void _showAdsense(){
    _adHelper.showInterstitialAd();
  }

 void _showWinnerDialog(String winnerSymbol, String winnerName) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impede fechar clicando fora do diálogo
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          winnerSymbol == '-' ? "Empate!" : "Parabéns, $winnerName!",
        ),
        content: RichText(
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
                        size: 24.0,
                        color: winnerSymbol == 'X' ? Colors.red : Colors.blue,
                      ),
                    ),
                    const TextSpan(text: " venceu!"),
                  ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
              _resetBoard(); // Reseta o tabuleiro automaticamente
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
  }



  @override
  Widget build(BuildContext context) {
    const double titleFontSize = 25;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "TIC NEXUS",
          style: TextStyle(fontSize: titleFontSize),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: (titleFontSize + 5),
      ),
body: Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    // Placar
    ScoreBoard(
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

    // Tabuleiro
    Expanded(
      child: Center(
        child: GameTable(gameLogic: _gameLogic),
      ),
    ),

    // Botões
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            imageName: 'start.png',
            height: 100.0,
            onPressed: _resetBoard,
          ),
          CustomIconButton(
            imageName: 'adsense.png',
            height: 80.0,
            onPressed: _showAdsense,
          ),
          CustomIconButton(
            imageName: 'reset.png',
            height: 100.0,
            onPressed: _resetGame,
          ),
        ],
      ),
    ),

    // Banner Ad
    if (_bannerAd != null)
      Container(
        color: Colors.grey.shade200, // Para visualização (remova depois)
        alignment: Alignment.bottomCenter,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
  ],
),


    );
  }
}
