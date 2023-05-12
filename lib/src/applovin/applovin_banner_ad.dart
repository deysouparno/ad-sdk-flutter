import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:applovin_max/applovin_max.dart';

abstract class ApplovinBannerAd {
  static Future<AdResult<MaxAd>> load({
    required String adUnitId,
  }) async {
    final c = Completer<AdResult<MaxAd>>();
    AppLovinMAX.setBannerListener(
      AdViewAdListener(
        onAdLoadedCallback: (ad) {
          if (ad.adUnitId == adUnitId) c.complete(AdResult<MaxAd>(ad: ad));
        },
        onAdLoadFailedCallback: (id, error) {
          if (id == adUnitId) c.complete(AdResult<MaxAd>(error: error.message));
        },
        onAdClickedCallback: (_) => null,
        onAdCollapsedCallback: (_) => null,
        onAdExpandedCallback: (_) => null,
      ),
    );
    AppLovinMAX.loadBanner(adUnitId);

    return c.future;
  }
}
