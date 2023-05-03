import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/rewarded_ad_interface/rewarded_ad_interface.dart';
import 'package:applovin_max/applovin_max.dart';

class RewardedAppLovinAdProvider implements RewardedAdInterface {
  @override
  String get adProviderName => AdProvider.APPLOVIN.name.toLowerCase();

  @override
  Future<void> loadRewardedAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    Map? configuration = await AppLovinMAX.initialize(adUnit);
    if (configuration != null) {
      AppLovinMAX.loadRewardedAd(adUnit);
      AppLovinMAX.setRewardedAdListener(RewardedAdListener(
          onAdLoadedCallback: (MaxAd ad) {},
          onAdLoadFailedCallback: (maxAd, maxError) {
            onAdFailedToLoad(maxError.toString());
          },
          onAdDisplayedCallback: (maxAd) {},
          onAdDisplayFailedCallback: (maxAd, maxError) {},
          onAdClickedCallback: (maxAd) {},
          onAdHiddenCallback: (maxAd) {},
          onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {}));
    }
  }
}
