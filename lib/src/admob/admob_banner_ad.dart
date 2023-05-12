import 'dart:async';

import 'package:adsdk/src/internal/models/ad_result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobBannerAd {
  static Future<AdResult<BannerAd>> load({
    required String adUnitId,
    required AdRequest request,
    required AdSize adSize,
  }) async {
    final c = Completer<AdResult<BannerAd>>();
    BannerAd(
      adUnitId: adUnitId,
      request: request,
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) => c.complete(AdResult(ad: ad as BannerAd)),
        onAdFailedToLoad: (_, error) => c.complete(
          AdResult(error: error.message),
        ),
      ),
    ).load();
    return c.future;
  }
}
