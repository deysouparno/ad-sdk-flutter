import 'package:adsdk/src/adsdk/adsdk_appopen_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_banner_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_interstitial_ad.dart';
import 'package:adsdk/src/adsdk/adsdk_lifecycle_reactor.dart';
import 'package:adsdk/src/adsdk/adsdk_rewarded_ad.dart';
import 'package:adsdk/src/adsdk/widgets/adsdk_banner_ad_widget.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/models/ad_sdk_configuration.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/services/api_service.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdSdk {
  static late AdSdkConfiguration _configuration;
  static final Map<String, AdSdkAdConfig> _ads = {};
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize({
    required String bundleId,
    required String platform,
    required AdSdkConfiguration configuration,
    String? applovinSdkKey,
  }) async {
    _configuration = configuration;

    final resp = await ApiService.fetchAds(
      packageId: bundleId,
      platform: platform,
    );

    if (resp == null) return;
    if (!resp.app.showAppAds) {
      AdSdkLogger.error("Ads disabled from backend.");
      return;
    }

    for (AdSdkAdConfig ad in resp.app.ads) {
      _ads[ad.adName] = ad;
    }

    if (_configuration.googleAdsTestDevices.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: _configuration.googleAdsTestDevices,
      ));
    }

    await MobileAds.instance.initialize();
    AdSdkLogger.debug("Google ads initialized.");

    if (applovinSdkKey != null) {
      if (_configuration.applovinTestDevices.isNotEmpty) {
        AppLovinMAX.setTestDeviceAdvertisingIds(
          _configuration.applovinTestDevices,
        );
      }
      await AppLovinMAX.initialize(applovinSdkKey);

      AdSdkLogger.debug("Applovin initialized.");
    }

    AdSdkLogger.info("AdSdk initialized.");

    _isInitialized = true;
  }

  static void loadAd({
    required String adName,
    AdSdkInterstitialAdListener? adSdkInterstitialAdListener,
    AdSdkAppOpenAdListener? adSdkAppOpenAdListener,
    AdSdkRewardedAdListener? adSdkRewardedAdListener,
    AdSdkBannerAdListener? adSdkBannerAdListener,
  }) {
    if (!_isInitialized) {
      const error = "AdSdk not initialized.";
      adSdkInterstitialAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkAppOpenAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkRewardedAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      return;
    }

    final ad = _ads[adName];

    if (ad == null) {
      const error = "Please provided correct adName.";
      adSdkInterstitialAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkAppOpenAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkRewardedAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkBannerAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      return;
    }
    if (!ad.isActive) {
      final error = "Ad '$adName' not active.";

      adSdkInterstitialAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkAppOpenAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkRewardedAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      adSdkBannerAdListener?.onAdFailedToLoad([AdSdkLogger.error(error)]);
      return;
    }

    AdSdkLogger.debug("Loading ad - '$adName'");
    if (ad.adType == AdUnitType.interstitial) {
      AdSdkInterstitialAd.load(
        adName: adName,
        primaryAdProvider: ad.primaryAdprovider,
        secondaryAdProvider: ad.secondaryAdprovider,
        primaryIds: ad.primaryIds,
        secondaryIds: ad.secondaryIds,
        adRequest: _configuration.adRequest,
        adManagerAdRequest: _configuration.adManagerAdRequest,
        adSdkInterstitialAdListener: adSdkInterstitialAdListener,
      );
    } else if (ad.adType == AdUnitType.appOpen) {
      AdSdkAppOpenAd.load(
        adName: adName,
        primaryAdProvider: ad.primaryAdprovider,
        secondaryAdProvider: ad.secondaryAdprovider,
        primaryIds: ad.primaryIds,
        secondaryIds: ad.secondaryIds,
        adRequest: _configuration.adRequest,
        adSdkAppOpenAdListener: adSdkAppOpenAdListener,
      );
    } else if (ad.adType == AdUnitType.rewarded) {
      AdSdkRewardedAd.load(
        adName: adName,
        primaryAdProvider: ad.primaryAdprovider,
        secondaryAdProvider: ad.secondaryAdprovider,
        primaryIds: ad.primaryIds,
        secondaryIds: ad.secondaryIds,
        adRequest: _configuration.adRequest,
        adSdkRewardedAdListener: adSdkRewardedAdListener,
      );
    } else if (ad.adType == AdUnitType.banner) {
      AdSdkBannerAd.load(
        adName: adName,
        primaryAdProvider: ad.primaryAdprovider,
        secondaryAdProvider: ad.secondaryAdprovider,
        primaryIds: ad.primaryIds,
        secondaryIds: ad.secondaryIds,
        adRequest: _configuration.adRequest,
        adManagerAdRequest: _configuration.adManagerAdRequest,
        adSdkBannerAdListener: adSdkBannerAdListener,
        adSdkAdSize: ad.size,
      );
    }
  }

  static Widget createBannerAd(String adName) {
    final ad = _ads[adName];
    if (ad == null) {
      AdSdkLogger.error("Please provided correct adName.");
      return const SizedBox.shrink();
    }
    return AdSdkBannerAdWidget(adSdkAdConfig: ad);
  }

  static void setAppOpenLifecycleReactor(String adName) {
    final config = _ads[adName];
    if (config == null) return;
    AdSdkLogger.info("Setting up AppOpenLifecycleReactor for ad $adName");
    AppLifecycleReactor(config: config).listenToAppStateChanges();
  }
}
