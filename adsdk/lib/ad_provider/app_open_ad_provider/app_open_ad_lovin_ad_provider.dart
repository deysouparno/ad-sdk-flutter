import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/app_open_ad_provider.dart';
import 'package:applovin_max/applovin_max.dart';

class AppOpenAppLovinAdProvider extends AppOpenAdAdProvider {
  @override
  String get adProviderName => AdProvider.APPLOVIN.name.toLowerCase();

  @override
  Future<void> loadAppOpenAd(
      {required String adUnit,
      required String adProvider,
      required Function(MaxAd p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    {
      if (adProviderName != adProvider) {
        return;
      }
      Map? configuration = await AppLovinMAX.initialize(adUnit);
      if (configuration != null) {
        AppLovinMAX.loadAppOpenAd(adUnit);
        AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
            onAdLoadedCallback: (maxAd) {
              onAdLoaded(maxAd);
            },
            onAdLoadFailedCallback: (adUnit, maxError) {
              onAdFailedToLoad(maxError.toString());
            },
            onAdDisplayedCallback: (maxAd) {},
            onAdDisplayFailedCallback: (maxAd, error) {},
            onAdClickedCallback: (maxAd) {},
            onAdHiddenCallback: (maxAd) {}));
      }
    }
  }
}
