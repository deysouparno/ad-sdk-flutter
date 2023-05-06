import 'dart:async';

import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/native_ad_interface/native_ad_interface.dart';
import 'package:adsdk/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdMobProvider extends NativeAdInterface {
  @override
  String get adProviderName => AdProvider.ADMOB.name.toLowerCase();

  @override
  Future<void> loadNativeAd(
      {required String adUnit,
      required String adProvider,
      required Function(dynamic p1) onAdLoaded,
      required Function(String p1) onAdFailedToLoad}) async {
    if (adProviderName != adProvider) {
      return;
    }
    final Completer completer = Completer<bool>();
    NativeAd(
      adUnitId: adUnit,
      request: Utils.getAdRequest(),
      factoryId: 'nativeAdView',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          completer.complete(false);
        },
      ),
    ).load();
    return completer.future;
  }
}
