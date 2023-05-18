import 'dart:async';

import 'package:adsdk/src/internal/models/ad_sdk_raw_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobNativeAd {
  static Future<AdSdkRawAd<Ad>> load({
    required String adUnitId,
    required AdRequest request,
    required String factoryId,
    required String buttonColor,
    required String textColor,
  }) async {
    final c = Completer<AdSdkRawAd<Ad>>();
    NativeAd(
      customOptions: {
        "buttonColor": buttonColor,
        "textColor": textColor,
      },
      adUnitId: adUnitId,
      request: request,
      listener: NativeAdListener(
        onAdLoaded: (ad) => c.complete(AdSdkRawAd(ad: ad as NativeAd)),
        onAdFailedToLoad: (_, error) =>
            c.complete(AdSdkRawAd(error: error.message)),
      ),
      factoryId: factoryId,
    ).load();
    return c.future;
  }
}
