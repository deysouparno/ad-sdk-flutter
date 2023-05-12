import 'package:adsdk/adsdk.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/models/api_response.dart';

class AppLifecycleReactor {
  final AdSdkAdConfig config;

  late dynamic ad;
  late AdProvider adProvider;

  AppLifecycleReactor({
    required this.config,
  });

  void listenToAppStateChanges() {
    _loadAppOpenAd();
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.foreground) {
      showAppOpenAd();
    }
  }

  void showAppOpenAd() {
    if (adProvider == AdProvider.admob) {
      ad.show();
    } else {
      AppLovinMAX.showAppOpenAd(ad.adUnitId);
    }
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AdSdk.loadAd(
      adName: config.adName,
      adSdkAppOpenAdListener: AdSdkAppOpenAdListener(
        onAdFailedToLoad: (errors) {},
        onAdmobAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.admob;
        },
        onApplovinAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.applovin;
        },
      ),
    );
  }
}
