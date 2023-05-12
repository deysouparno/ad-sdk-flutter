import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmanagerBannerAd {
  static Future<AdResult<AdManagerBannerAd>> load({
    required String adUnitId,
    required AdManagerAdRequest request,
    required AdSize adSize,
  }) async {
    final c = Completer<AdResult<AdManagerBannerAd>>();
    AdManagerBannerAd(
      adUnitId: adUnitId,
      request: request,
      sizes: [adSize],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (ad) => c.complete(AdResult(ad: ad as AdManagerBannerAd)),
        onAdFailedToLoad: (_, error) => c.complete(
          AdResult(error: error.message),
        ),
      ),
    ).load();
    return c.future;
  }
}
