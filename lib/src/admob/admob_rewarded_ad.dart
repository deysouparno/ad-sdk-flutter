import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobRewardedAd {
  static Future<AdResult<RewardedAd>> load({
    required String adUnitId,
    required AdRequest request,
  }) async {
    final c = Completer<AdResult<RewardedAd>>();
    RewardedAd.load(
      adUnitId: adUnitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => c.complete(AdResult(ad: ad)),
        onAdFailedToLoad: (error) => c.complete(
          AdResult(error: error.message),
        ),
      ),
    ); 
    return c.future;
  }
}
