import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/rewarded_ad_interface/rewarded_ad_interface.dart';
import 'package:adsdk/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdMobAdProvider implements RewardedAdInterface {
  @override
  String get adProviderName => AdProvider.ADMOB.name.toLowerCase();

  @override
  Future<void> loadRewardedAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    RewardedAd.load(
      adUnitId: adUnit,
      request: Utils.getAdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          onAdFailedToLoad(error.toString());
        },
      ),
    );
  }
}
