import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:applovin_max/applovin_max.dart';

import 'package:adsdk/src/admob/admob_appopen_ad.dart';
import 'package:adsdk/src/applovin/applovin_appopen_ad.dart';
import 'package:adsdk/src/internal/models/ad_sdk_ad.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';

abstract class AdSdkAppOpenAd {
  static load({
    required AdSdkAdConfig adConfig,
    required Function(List<String> errors) onAdFailedToLoad,
    required Function(AdSdkAd ad) onAdLoaded,
  }) async {
    final primaryAdProvider = adConfig.primaryAdprovider;
    final secondaryAdProvider = adConfig.secondaryAdprovider;
    final primaryIds = adConfig.primaryIds;
    final secondaryIds = adConfig.secondaryIds;
    final List<String> errors = [];

    AdSdkAd ad = AdSdkAd(
      ad: null,
      adName: adConfig.adName,
      adUnitId: "",
      adProvider: primaryAdProvider,
      adUnitType: AdUnitType.appOpen,
    );

    for (var adUnitId in primaryIds) {
      ad = ad.copyWith(adUnitId: adUnitId);
      if (primaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinAppOpenAd.load(adUnitId);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: primaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobAppOpenAd.load(adUnitId);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: primaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    for (var adUnitId in secondaryIds) {
      ad = ad.copyWith(adUnitId: adUnitId, adProvider: secondaryAdProvider);

      if (secondaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinAppOpenAd.load(adUnitId);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: secondaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobAppOpenAd.load(adUnitId);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: secondaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    AdSdkLogger.error(
        "Failed to load ad - '${adConfig.adName}' with errors - $errors");
    onAdFailedToLoad(errors);
  }
}
