import 'dart:async';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobBannerAd {
  static Future<AdSdkRawAd<Ad>> load({
    required String adUnitId,
    required AdSize adSize,
  }) async {
    final c = Completer<AdSdkRawAd<Ad>>();
    BannerAd(
      adUnitId: adUnitId,
      request: AdSdkState.adSdkConfig.adRequest,
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) => c.complete(AdSdkRawAd(ad: ad)),
        onAdFailedToLoad: (_, error) => c.complete(
          AdSdkRawAd(error: error.message),
        ),
      ),
    ).load();
    return c.future;
  }
}
