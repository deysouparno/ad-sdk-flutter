import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmanagerInterstitialAd {
  static Future<AdResult<AdManagerInterstitialAd>> load({
    required String adUnitId,
    required AdManagerAdRequest request,
  }) async {
    final c = Completer<AdResult<AdManagerInterstitialAd>>();
    AdManagerInterstitialAd.load(
      adUnitId: adUnitId,
      request: request,
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (ad) => c.complete(AdResult(ad: ad)),
        onAdFailedToLoad: (error) => c.complete(
          AdResult(error: error.message),
        ),
      ),
    );
    return c.future;
  }
}
