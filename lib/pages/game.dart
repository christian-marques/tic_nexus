import 'dart:developer';

import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
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

  void _showWinnerDialog(String winnerSymbol, String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar clicando fora do diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            winnerSymbol == '-' ? "Empate!" : "Parabéns, $winnerName!"),
          content: Text(
            winnerSymbol == '-' ? 
              """$nameX e $nameO,\njogaram muito bem!""" : 
              """O $winnerSymbol venceu!""",
            style: const TextStyle(fontSize: 18.0),
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bloco do placar
                ScoreBoard(
                  players: [
                    PlayerSection(
                      icon: Icons.close,
                      labelName: "Jogador X",
                      initialName: nameX,
                      score: scoreX, // Placar inicial fixo.
                      iconColor: Colors.red,
                      backgroundColor: const Color(0xFFFFCDD2),
                    ),
                    PlayerSection(
                      icon: Icons.circle_outlined,
                      labelName: "Jogador O",
                      initialName: nameO,
                      score: scoreO, // Placar inicial fixo.
                      iconColor: Colors.blue,
                      backgroundColor: const Color(0xFFBBDEFB),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: GameTable(gameLogic: _gameLogic), // Apenas exibe o tabuleiro.
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0), // Ajusta o espaçamento geral
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaço igual entre os botões
                    children: [
                      ElevatedButton(
                        onPressed: _resetBoard, // Reseta apenas o tabuleiro.
                        child: const Text('Próxima Partida'),
                      ),
                      ElevatedButton(
                        onPressed: _resetGame, // Reseta o jogo e o placar.
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ),
                if (_bannerAd != null)
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: FloatingActionButton(
              onPressed: () {
                _adHelper.showInterstitialAd();
              },
              child: const Icon(Icons.ads_click_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
