import 'package:tic_nexus/models/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:tic_nexus/models/score_board.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:developer';


class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage>{

  static double titleFontSize = 25;
  static Color backgroundColor = Colors.grey.shade200;

  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose(); // Libera o recurso do banner ao sair da página
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          log("Falhou ao carregar o Banner ad: ${err.message}");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TIC NEXUS",
          style: TextStyle(fontSize: titleFontSize),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: (titleFontSize + 5),
      ),

      body: Container(
        color: backgroundColor,
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
                  backgroundColor: const Color(0xFFFFCDD2), // Aproximado de Colors.redAccent.shade100
                ),
                PlayerSection(
                  icon: Icons.circle_outlined,
                  labelName: "Nome do jogador 2",
                  initialName: "Jogador 2",
                  score: 0,
                  iconColor: Colors.blue,
                  backgroundColor: const Color(0xFFBBDEFB), // Aproximado de Colors.blueAccent.shade100
                ),
              ],
            ),
            
            Expanded(
              child: Center(
                child: Text(
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
    );
  }
}
