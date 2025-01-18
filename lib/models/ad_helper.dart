import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:developer';

class AdHelper {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  /// IDs de unidade de anúncio
  static String get bannerAdUnitId => 'ca-app-pub-3940256099942544/9214589741'; // Teste
  static String get interstitialAdUnitId => 'ca-app-pub-3940256099942544/1033173712'; // Teste

  /// Carregar Banner Ad
  void loadBannerAd(Function(BannerAd?) onBannerLoaded) {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log("Banner Ad carregado com sucesso.");
          onBannerLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          log("Falha ao carregar o Banner Ad: ${error.message}");
          ad.dispose();
          onBannerLoaded(null);
        },
      ),
    )..load();
  }

  /// Carregar Interstitial Ad
  void loadInterstitialAd(Function(InterstitialAd?) onInterstitialLoaded) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log("Interstitial Ad carregado com sucesso.");
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              log("Interstitial Ad fechado.");
              ad.dispose();
              _interstitialAd = null; // Limpa o recurso
              loadInterstitialAd(onInterstitialLoaded); // Recarrega o anúncio
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              log("Erro ao exibir Interstitial Ad: ${error.message}");
              ad.dispose();
            },
          );
          onInterstitialLoaded(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          log("Falha ao carregar Interstitial Ad: ${error.message}");
          onInterstitialLoaded(null);
        },
      ),
    );
  }

  /// Exibir Interstitial Ad
  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Limpa após exibir
    } else {
      log("Nenhum Interstitial Ad carregado.");
    }
  }

  /// Descartar recursos de anúncios
  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
