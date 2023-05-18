import 'dart:async';

import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:applovin_max/applovin_max.dart';

abstract class ApplovinRewardedAd {
  static Future<AdSdkRawAd<MaxAd>> load(String adUnitId) async {
    final c = Completer<AdSdkRawAd<MaxAd>>();
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          if (ad.adUnitId == adUnitId) c.complete(AdSdkRawAd(ad: ad));
        },
        onAdLoadFailedCallback: (id, error) {
          if (id == adUnitId) {
            c.complete(AdSdkRawAd(error: error.message));
          }
        },
        onAdDisplayedCallback: (ad) => null,
        onAdDisplayFailedCallback: (ad, error) => null,
        onAdClickedCallback: (ad) => null,
        onAdHiddenCallback: (ad) => null,
        onAdReceivedRewardCallback: (ad, reward) => null,
      ),
    );
    AppLovinMAX.loadRewardedAd(adUnitId);

    return c.future;
  }
}
