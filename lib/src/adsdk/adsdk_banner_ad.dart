import 'dart:async';

import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/admanager/admanager_banner_ad.dart';
import 'package:adsdk/src/admob/admob_banner_ad.dart';
import 'package:adsdk/src/internal/models/ad_sdk_ad.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';

abstract class AdSdkBannerAd {
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
      adUnitType: AdUnitType.banner,
    );

    try {
      for (var adUnitId in primaryIds) {
        ad = ad.copyWith(adUnitId: adUnitId);

        if (primaryAdProvider == AdProvider.admanager) {
          final resp = await AdmanagerBannerAd.load(
            adUnitId: adUnitId,
            adSize: adConfig.size.admobSize,
          ).timeout(Duration(milliseconds: adConfig.primaryAdloadTimeoutMs));
          if (resp.ad != null) {
            AdSdkLogger.adLoadedLog(
                adName: adConfig.adName, adProvider: primaryAdProvider);
            return onAdLoaded(ad.copyWith(ad: resp.ad));
          }
          if (resp.error != null) errors.add(resp.error!);
        } else {
          final resp = await AdmobBannerAd.load(
            adUnitId: adUnitId,
            adSize: adConfig.size.admobSize,
          ).timeout(Duration(milliseconds: adConfig.primaryAdloadTimeoutMs));
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

        if (secondaryAdProvider == AdProvider.admanager) {
          final resp = await AdmanagerBannerAd.load(
            adUnitId: adUnitId,
            adSize: adConfig.size.admobSize,
          );
          if (resp.ad != null) {
            AdSdkLogger.adLoadedLog(
                adName: adConfig.adName, adProvider: secondaryAdProvider);
            return onAdLoaded(ad.copyWith(ad: resp.ad));
          }
          if (resp.error != null) errors.add(resp.error!);
        } else {
          final resp = await AdmobBannerAd.load(
            adUnitId: adUnitId,
            adSize: adConfig.size.admobSize,
          );
          if (resp.ad != null) {
            AdSdkLogger.adLoadedLog(
                adName: adConfig.adName, adProvider: secondaryAdProvider);
            return onAdLoaded(ad.copyWith(ad: resp.ad));
          }
          if (resp.error != null) errors.add(resp.error!);
        }
      }
    } on TimeoutException catch (e) {
      errors.add("TimeoutException: ${e.message}");
    } catch (e) {
      errors.add("Exception: ${e.toString()}");
    }

    AdSdkLogger.error(
        "Failed to load ad - '${adConfig.adName}' with errors - $errors");
    onAdFailedToLoad(errors);
  }
}
