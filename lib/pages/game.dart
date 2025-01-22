import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:tic_nexus/models/dialog_screen.dart';
import 'package:tic_nexus/models/icon_button.dart';
import 'package:tic_nexus/models/score_board.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_nexus/models/game_table.dart';
import 'package:tic_nexus/models/game_logic.dart';
import 'package:tic_nexus/models/tutorials.dart';

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
  final TextEditingController controllerX = TextEditingController(text: 'Jogador X');
  final TextEditingController controllerO = TextEditingController(text: 'Jogador O');
  bool isEditingNames = true;
  bool isWaitingGameStart = true;
  bool isPlayerOCPU = false; // Inicialmente como Player vs Player

  bool get isGameRunning => _gameLogic.isGameRunning();

  @override
  void initState() {
    super.initState();

    setState(() {
      isWaitingGameStart = true;
    });

    _adHelper.loadBannerAd((banner) {
      setState(() {
        _bannerAd = banner;
      });
    });

    _adHelper.loadInterstitialAd((interstitial) {
      setState(() {});
    });

    _gameLogic.onWinnerDeclared = (winnerSymbol) {
      String winnerName = winnerSymbol == "X" ? controllerX.text : controllerO.text;
      setState(() {
        if (winnerSymbol == "X") {
          scoreX++;
        } else if (winnerSymbol == "O") {
          scoreO++;
        }
      });
      _showWinnerDialog(winnerSymbol, winnerName);
    };
  }

  @override
  void dispose() {
    _adHelper.disposeAds();
    controllerX.dispose();
    controllerO.dispose();
    super.dispose();
  }

  void _startGame() {
    if (!isGameRunning){
      setState(() {
        _gameLogic.startGame();
        isEditingNames = false;
        isWaitingGameStart = false;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _gameLogic.resetBoard();
      _gameLogic.finishGame();
      isEditingNames = true;
      isWaitingGameStart = true;
      scoreX = 0;
      scoreO = 0;
      controllerX.text = 'Jogador X';
      controllerO.text = 'Jogador O';
    });
  }

  void _showWinnerDialog(String winnerSymbol, String winnerName) {
    final Widget body = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 18.0, color: Colors.black),
        children: winnerSymbol == '-'
            ? [
                TextSpan(
                  text: "${controllerX.text} e ${controllerO.text},\n",
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
                    size: 24,
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
      onConfirmed: (){
        _adHelper.showInterstitialAd();
        _gameLogic.resetBoard(); // Reinicia o tabuleiro
        _gameLogic.startGame();  // Recomeça o jogo automaticamente
        setState(() {
          isEditingNames = false;
        });
      }
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
      resizeToAvoidBottomInset: true, // Permite o conteúdo se ajustar ao teclado
      body: Stack(
        children: [
          // Conteúdo principal
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: _bannerAd != null ? _bannerAd!.size.height.toDouble() : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Placar
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.001,
                    horizontal: screenWidth * 0.001,
                  ),
                  child: ScoreBoard(
                    players: [
                      PlayerSection(
                        icon: Icons.close,
                        labelName: "Jogador X",
                        controller: controllerX,
                        score: scoreX,
                        iconColor: Colors.red,
                        backgroundColor: const Color(0xFFFFCDD2),
                        isEditable: isEditingNames,
                      ),
                      PlayerSection(
                        icon: Icons.circle_outlined,
                        labelName: "Jogador O",
                        controller: controllerO,
                        score: scoreO,
                        iconColor: Colors.blue,
                        backgroundColor: const Color(0xFFBBDEFB),
                        isEditable: isEditingNames,
                      ),
                    ],
                  ),
                ),

                // Tabuleiro com tutorial
                SizedBox(
                  height: screenHeight * 0.47,
                  child: Stack(
                    children: [
                      GameTable(gameLogic: _gameLogic),
                      if (isWaitingGameStart)
                        const TutorialOverlay(),
                    ],
                  ),
                ),

                // Botões
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.10,
                    vertical: screenHeight * 0.00,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        imageName: 'start.png',
                        width: screenWidth * 0.27,
                        isGameRunning: isGameRunning,
                        onPressed: _startGame,
                      ),
                      CustomIconButton(
                        imageName: 'adsense.png',
                        width: screenWidth * 0.16,
                        isGameRunning: isGameRunning,
                        onPressed: _adHelper.showInterstitialAd,
                      ),
                      CustomIconButton(
                        imageName: 'reset.png',
                        width: screenWidth * 0.27,
                        isGameRunning: isGameRunning,
                        onPressed: _resetGame,
                      ),
                    ],
                  ),
                ),

                // Banner Ad no final da página
                if (_bannerAd != null)
                  Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 196, 193, 193),
                      border: Border(
                        top: BorderSide(
                          color: const Color.fromARGB(255, 185, 181, 181),
                        ),
                      ),
                    ),
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ],
            ),
          ),

// Botão flutuante
          Positioned(
            top: screenHeight * 0.001,
            right: screenWidth * 0.02,
            child: CustomIconButton(
              imageName: isPlayerOCPU ? 'player_vs_cpu.png' : 'player_vs_player.png',
              width: screenWidth * 0.12, // Ajuste do tamanho do botão
              isGameRunning: isGameRunning,
              onPressed: isGameRunning
                  ? () {} // Botão desabilitado quando o jogo está em execução
                  : () {
                      setState(() {
                        isPlayerOCPU = !isPlayerOCPU;
                        if (isPlayerOCPU) {
                          _gameLogic.setPlayerOasCPU();
                        } else {
                          _gameLogic.setPlayerOasHuman();
                        }
                      });
                    },
            ),
          ),



        ],
      ),
    );
  }






}
