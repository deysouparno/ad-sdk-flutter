import 'dart:async';

import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:applovin_max/applovin_max.dart';

abstract class ApplovinBannerAd {
  static Future<AdSdkRawAd<MaxAd>> load(String adUnitId) async {
    final c = Completer<AdSdkRawAd<MaxAd>>();
    AppLovinMAX.setBannerListener(
      AdViewAdListener(
        onAdLoadedCallback: (ad) {
          if (ad.adUnitId == adUnitId) c.complete(AdSdkRawAd(ad: ad));
        },
        onAdLoadFailedCallback: (id, error) {
          if (id == adUnitId) {
            c.complete(AdSdkRawAd(error: error.message));
          }
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
