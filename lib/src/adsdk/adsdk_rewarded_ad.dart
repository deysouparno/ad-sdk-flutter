import 'package:adsdk/src/admob/admob_rewarded_ad.dart';
import 'package:adsdk/src/applovin/applovin_rewarded_ad.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/enums/ad_provider.dart';

abstract class AdSdkRewardedAd {
  static void load({
    required String adName,
    required AdProvider primaryAdProvider,
    required AdProvider secondaryAdProvider,
    required List<String> primaryIds,
    required List<String> secondaryIds,
    required AdRequest adRequest,
    AdSdkRewardedAdListener? adSdkRewardedAdListener,
  }) async {
    final List<String> errors = [];

    for (var ad in primaryIds) {
      if (primaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinRewardedAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkRewardedAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobRewardedAd.load(
          adUnitId: ad,
          request: adRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkRewardedAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    for (var ad in secondaryIds) {
      if (secondaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinRewardedAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkRewardedAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobRewardedAd.load(
          adUnitId: ad,
          request: adRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkRewardedAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    AdSdkLogger.error("Failed to load ad - '$adName' with errors - $errors");
    adSdkRewardedAdListener?.onAdFailedToLoad(errors);
  }
}

class AdSdkRewardedAdListener {
  final Function(List<String> errors) onAdFailedToLoad;
  final Function(RewardedAd ad) onAdmobAdLoaded;
  final Function(MaxAd ad) onApplovinAdLoaded;

  AdSdkRewardedAdListener({
    required this.onAdFailedToLoad,
    required this.onAdmobAdLoaded,
    required this.onApplovinAdLoaded,
  });
}
