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

  int _scoreX = 0;
  int _scoreO = 0;
  bool _gameEnded = false;
  String _winnerSymbol = '';

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

    _gameLogic.setOnStateChanged(() {
      setState(() {
        if (_gameLogic.checkVictory()) {
          _gameEnded = true;
          _winnerSymbol = _gameLogic.getCurrentPlayer() == 'X' ? 'O' : 'X';

          if (_winnerSymbol == 'X') {
            _scoreX++;
          } else if (_winnerSymbol == 'O') {
            _scoreO++;
          }
        } else if (_gameLogic.checkDraw()) {
          _gameEnded = true;
          _winnerSymbol = '-'; // Empate.
        }
      });
    });
  }

  @override
  void dispose() {
    _adHelper.disposeAds();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      _gameEnded = false;
      _winnerSymbol = '';
      _gameLogic.resetBoard();
    });
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
                      initialName: "Jogador X",
                      score: _scoreX,
                      iconColor: Colors.red,
                      backgroundColor: const Color(0xFFFFCDD2),
                    ),
                    PlayerSection(
                      icon: Icons.circle_outlined,
                      labelName: "Jogador O",
                      initialName: "Jogador O",
                      score: _scoreO,
                      iconColor: Colors.blue,
                      backgroundColor: const Color(0xFFBBDEFB),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: _gameEnded
                        ? Container(
                            alignment: Alignment.center,
                            color: Colors.grey.shade300,
                            child: Text(
                              _winnerSymbol == '-'
                                  ? "Empate!"
                                  : _winnerSymbol,
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: _winnerSymbol == 'X'
                                    ? Colors.red
                                    : _winnerSymbol == 'O'
                                        ? Colors.blue
                                        : Colors.black,
                              ),
                            ),
                          )
                        : GameTable(gameLogic: _gameLogic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _resetGame, // Reseta apenas o tabuleiro.
                        child: const Text('Próxima Partida'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _scoreX = 0;
                            _scoreO = 0; // Reseta o placar.
                            _resetGame();
                          });
                        },
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
