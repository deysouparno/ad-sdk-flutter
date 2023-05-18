import 'dart:async';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobRewardedAd {
  static Future<AdSdkRawAd<Ad>> load(String adUnitId) async {
    final c = Completer<AdSdkRawAd<Ad>>();
    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdSdkState.adSdkConfig.adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => c.complete(AdSdkRawAd(ad: ad)),
        onAdFailedToLoad: (error) => c.complete(
          AdSdkRawAd(error: error.message),
        ),
      ),
    );
    return c.future;
  }
}
