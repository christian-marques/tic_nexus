import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:tic_nexus/models/score_board.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final AdHelper _adHelper = AdHelper();
  BannerAd? _bannerAd;

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
  }

  @override
  void dispose() {
    _adHelper.disposeAds(); // Limpa os recursos
    super.dispose();
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
          // Layout principal
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bloco do placar
                ScoreBoard(
                  players: [
                    PlayerSection(
                      icon: Icons.close,
                      labelName: "Nome do jogador 1",
                      initialName: "Jogador 1",
                      score: 0,
                      iconColor: Colors.red,
                      backgroundColor: const Color(0xFFFFCDD2),
                    ),
                    PlayerSection(
                      icon: Icons.circle_outlined,
                      labelName: "Nome do jogador 2",
                      initialName: "Jogador 2",
                      score: 0,
                      iconColor: Colors.blue,
                      backgroundColor: const Color(0xFFBBDEFB),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: const Text(
                      "Bloco de jogos da velha aqui",
                      style: TextStyle(fontSize: 20),
                    ),
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

          // Botão flutuante sobreposto
          Positioned(
            top: 8.0,
            left: 8.0,
            child: FloatingActionButton(
              onPressed: () {
                _adHelper.showInterstitialAd(); // Exibe o Interstitial Ad
              },
              child: const Icon(Icons.ads_click_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
