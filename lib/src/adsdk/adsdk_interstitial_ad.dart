import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/admanager/admanager_interstitial_ad.dart';
import 'package:adsdk/src/admob/admob_interstitial_ad.dart';
import 'package:adsdk/src/applovin/applovin_interstitial_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';

abstract class AdSdkInterstitialAd {
  static void load({
    required String adName,
    required AdProvider primaryAdProvider,
    required AdProvider secondaryAdProvider,
    required List<String> primaryIds,
    required List<String> secondaryIds,
    required AdRequest adRequest,
    required AdManagerAdRequest adManagerAdRequest,
    AdSdkInterstitialAdListener? adSdkInterstitialAdListener,
  }) async {
    final List<String> errors = [];

    for (var ad in primaryIds) {
      if (primaryAdProvider == AdProvider.admanager) {
        final resp = await AdmanagerInterstitialAd.load(
          adUnitId: ad,
          request: adManagerAdRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkInterstitialAdListener?.onAdmanagerAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else if (primaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinInterstitialAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkInterstitialAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobInterstitialAd.load(
          adUnitId: ad,
          request: adRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: primaryAdProvider);
          adSdkInterstitialAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    for (var ad in secondaryIds) {
      if (secondaryAdProvider == AdProvider.admanager) {
        final resp = await AdmanagerInterstitialAd.load(
          adUnitId: ad,
          request: adManagerAdRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkInterstitialAdListener?.onAdmanagerAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else if (secondaryAdProvider == AdProvider.applovin &&
          (await AppLovinMAX.isInitialized() ?? false)) {
        final resp = await ApplovinInterstitialAd.load(adUnitId: ad);
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkInterstitialAdListener?.onApplovinAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      } else {
        final resp = await AdmobInterstitialAd.load(
          adUnitId: ad,
          request: adRequest,
        );
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adName, adProvider: secondaryAdProvider);
          adSdkInterstitialAdListener?.onAdmobAdLoaded(resp.ad!);
          return;
        }
        if (resp.error != null) errors.add(resp.error!);
      }
    }

    AdSdkLogger.error("Failed to load ad - '$adName' with errors - $errors");
    adSdkInterstitialAdListener?.onAdFailedToLoad(errors);
  }
}

class AdSdkInterstitialAdListener {
  final Function(List<String> errors) onAdFailedToLoad;
  final Function(InterstitialAd ad) onAdmobAdLoaded;
  final Function(AdManagerInterstitialAd ad) onAdmanagerAdLoaded;
  final Function(MaxAd ad) onApplovinAdLoaded;

  AdSdkInterstitialAdListener({
    required this.onAdFailedToLoad,
    required this.onAdmobAdLoaded,
    required this.onAdmanagerAdLoaded,
    required this.onApplovinAdLoaded,
  });
}
