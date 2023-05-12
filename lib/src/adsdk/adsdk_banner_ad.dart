import 'package:adsdk/src/admanager/admanager_banner_ad.dart';
import 'package:adsdk/src/admob/admob_banner_ad.dart';
import 'package:adsdk/src/applovin/applovin_banner_ad.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/enums/ad_provider.dart';

abstract class AdSdkBannerAd {
  static void load({
    required String adName,
    required AdProvider primaryAdProvider,
    required AdProvider secondaryAdProvider,
    required List<String> primaryIds,
    required List<String> secondaryIds,
    required AdRequest adRequest,
    required AdManagerAdRequest adManagerAdRequest,
    required AdSdkAdSize adSdkAdSize,
    AdSdkBannerAdListener? adSdkBannerAdListener,
  }) async {
    final List<String> errors = [];

    for (var ad in primaryIds) {
      if (primaryAdProvider == AdProvider.admanager) {
        final resp = await AdmanagerBannerAd.load(
          adUnitId: ad,
          request: adManagerAdRequest,
          adSize: adSdkAdSize.adSize,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkBannerAdListener?.onAdmanagerAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else if (primaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinBannerAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkBannerAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobBannerAd.load(
          adUnitId: ad,
          request: adRequest,
          adSize: adSdkAdSize.adSize,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkBannerAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    AdSdkLogger.debug(
      "Primary ad provider (${primaryAdProvider.key}) failed for ad - $adName",
    );

    for (var ad in secondaryIds) {
      if (secondaryAdProvider == AdProvider.admanager) {
        final resp = await AdmanagerBannerAd.load(
          adUnitId: ad,
          request: adManagerAdRequest,
          adSize: adSdkAdSize.adSize,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkBannerAdListener?.onAdmanagerAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else if (secondaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinBannerAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkBannerAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobBannerAd.load(
          adUnitId: ad,
          request: adRequest,
          adSize: adSdkAdSize.adSize,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkBannerAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    AdSdkLogger.error("Failed to load ad - '$adName' with errors - $errors");
    adSdkBannerAdListener?.onAdFailedToLoad(errors);
  }
}

class AdSdkBannerAdListener {
  final Function(List<String> errors) onAdFailedToLoad;
  final Function(BannerAd ad) onAdmobAdLoaded;
  final Function(AdManagerBannerAd ad) onAdmanagerAdLoaded;
  final Function(MaxAd ad) onApplovinAdLoaded;

  AdSdkBannerAdListener({
    required this.onAdFailedToLoad,
    required this.onAdmobAdLoaded,
    required this.onAdmanagerAdLoaded,
    required this.onApplovinAdLoaded,
  });
}
