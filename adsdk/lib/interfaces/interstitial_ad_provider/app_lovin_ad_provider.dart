import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/interstitial_ad_provider/ad_provider.dart';
import 'package:applovin_max/applovin_max.dart';

class InterstitialAppLovinAdProvider implements InterstitialAdAdProvider {
  @override
  String get adProviderName => AdProvider.ADMOB.name.toLowerCase();

  @override
  Future<void> loadInterstitialAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {

    if (adProviderName != adProvider) {
      return;
    }

    Map? configuration = await AppLovinMAX.initialize(adUnit);

    if (configuration != null) {
      AppLovinMAX.loadInterstitial(adUnit);
      AppLovinMAX.setInterstitialListener(InterstitialListener(
          onAdLoadedCallback: (maxAd) {
            onAdLoaded(maxAd);
          },
          onAdLoadFailedCallback: (maxAd, maxError) {
            onAdFailedToLoad(maxError.toString());
          },
          onAdDisplayedCallback: (maxAd) {},
          onAdDisplayFailedCallback: (maxAd, maxError) {},
          onAdClickedCallback: (maxAd) {},
          onAdHiddenCallback: (maxAd) {}));
    }
  }
}
