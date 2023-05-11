import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:applovin_max/applovin_max.dart';

abstract class ApplovinInterstitialAd {
  static Future<AdResult<MaxAd>> load({
    required String adUnitId,
  }) async {
    final c = Completer<AdResult<MaxAd>>();
    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad) {
          if (ad.adUnitId == adUnitId) c.complete(AdResult<MaxAd>(ad: ad));
        },
        onAdLoadFailedCallback: (id, error) {
          if (id == adUnitId) c.complete(AdResult<MaxAd>(error: error.message));
        },
        onAdDisplayedCallback: (ad) => null,
        onAdDisplayFailedCallback: (ad, error) => null,
        onAdClickedCallback: (ad) => null,
        onAdHiddenCallback: (ad) => null,
      ),
    );
    AppLovinMAX.loadInterstitial(adUnitId);

    return c.future;
  }
}
