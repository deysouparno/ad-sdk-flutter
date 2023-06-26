import 'dart:async';

import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/admob/admob_native_ad.dart';
import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/models/ad_sdk_ad.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';

abstract class AdSdkNativeAd {
  static load({
    required AdSdkAdConfig adConfig,
    bool isDarkMode = false,
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
      adUnitType: AdUnitType.native,
    );

    try {
      for (var adUnitId in primaryIds) {
        ad = ad.copyWith(adUnitId: adUnitId);

        final resp = await AdmobNativeAd.load(
          adUnitId: adUnitId,
          request: primaryAdProvider == AdProvider.admanager
              ? AdSdkState.adSdkConfig.adManagerAdRequest
              : AdSdkState.adSdkConfig.adRequest,
          factoryId: adConfig.size.factoryId,
          buttonColor: isDarkMode ? adConfig.colorHexDark : adConfig.colorHex,
          textColor: isDarkMode ? adConfig.textColorDark : adConfig.textColor,
        ).timeout(Duration(milliseconds: adConfig.primaryAdloadTimeoutMs));
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: primaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
      }

      for (var adUnitId in secondaryIds) {
        final resp = await AdmobNativeAd.load(
          adUnitId: adUnitId,
          request: secondaryAdProvider == AdProvider.admanager
              ? AdSdkState.adSdkConfig.adManagerAdRequest
              : AdSdkState.adSdkConfig.adRequest,
          factoryId: adConfig.size.factoryId,
          buttonColor: isDarkMode ? adConfig.colorHexDark : adConfig.colorHex,
          textColor: isDarkMode ? adConfig.textColorDark : adConfig.textColor,
        ).timeout(Duration(milliseconds: adConfig.primaryAdloadTimeoutMs));
        if (resp.ad != null) {
          AdSdkLogger.adLoadedLog(
              adName: adConfig.adName, adProvider: secondaryAdProvider);
          return onAdLoaded(ad.copyWith(ad: resp.ad));
        }
        if (resp.error != null) errors.add(resp.error!);
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
