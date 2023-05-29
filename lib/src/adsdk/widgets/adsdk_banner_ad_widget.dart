import 'dart:async';
import 'dart:developer';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class AdSdkBannerAdWidget extends StatefulWidget {
  const AdSdkBannerAdWidget({super.key, required this.adName});

  final String adName;

  @override
  State<AdSdkBannerAdWidget> createState() => _AdSdkBannerAdWidgetState();
}

class _AdSdkBannerAdWidgetState extends State<AdSdkBannerAdWidget> {
  late final AdSdkAdConfig config;
  bool configLoaded = false;
  bool adLoaded = false;

  late AdSdkAd ad;
  late AdProvider adProvider;
  AdSdkAd? newAd;
  AdProvider? newAdProvider;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ad = AdSdkState.ads[widget.adName];
      if (ad == null) {
        AdSdkLogger.error("Please provided correct adName.");
        return;
      }
      config = ad;
      setState(() => configLoaded = true);
      AdSdkLogger.info(
        "Ad size of '${config.adName} - (${config.size.admobSize.height}, ${config.size.admobSize.width})'",
      );
      if (config.primaryAdprovider == AdProvider.applovin) {
        adProvider = AdProvider.applovin;
        setState(() => adLoaded = true);
        return;
      }
      loadAd();
      AdSdk.loadAd(
        adName: config.adName,
        onAdFailedToLoad: (errors) {
          setState(() => adLoaded = false);
          log(errors.toString());
        },
        onAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.admob;
          setState(() => adLoaded = false);
          setState(() => adLoaded = true);
          _timer = Timer.periodic(
            Duration(milliseconds: config.refreshRateMs),
            (_) {
              if (newAd != null) {
                setState(() => adLoaded = false);
                Future.delayed(
                  Duration(seconds: AdSdkState.adSdkConfig.isTestMode ? 1 : 0),
                  () {
                    ad = newAd!;
                    adProvider = newAdProvider!;
                    setState(() => adLoaded = true);
                  },
                );
              }
              loadAd();
            },
          );
        },
      );
    });
  }

  void loadAd() {
    AdSdk.loadAd(
      adName: config.adName,
      onAdFailedToLoad: (errors) {
        setState(() => adLoaded = false);
        log(errors.toString());
      },
      onAdLoaded: (ad) {
        newAd = ad;
        newAdProvider = AdProvider.admob;
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (configLoaded) {
      if (config.isActive) {
        if (adProvider == AdProvider.applovin) {
          if (config.size.applovinSize == AdFormat.banner) {
            AppLovinMAX.destroyBanner(ad.adUnitId);
          } else if (config.size.applovinSize == AdFormat.mrec) {
            AppLovinMAX.destroyMRec(ad.adUnitId);
          }
        } else {
          ad.dispose();
        }
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!configLoaded || !config.isActive) return const SizedBox();
    if (!config.isActive || !adLoaded) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.grey.withOpacity(0.6),
        period: const Duration(seconds: 1),
        child: Container(
          height: config.size.admobSize.height.toDouble(),
          width: config.size.admobSize.width.toDouble(),
          decoration: const BoxDecoration(color: Colors.grey),
        ),
      );
    }
    return adProvider == AdProvider.applovin
        ? MaxAdView(
            adUnitId: config.primaryIds.first,
            adFormat: config.size.applovinSize,
            listener: AdViewAdListener(
              onAdLoadedCallback: (ad) {
                if (ad.adUnitId == config.primaryIds.first) {
                  this.ad = AdSdkAd(
                    ad: ad,
                    adName: config.adName,
                    adUnitId: ad.adUnitId,
                    adProvider: adProvider,
                    adUnitType: AdUnitType.banner,
                  );
                }
              },
              onAdLoadFailedCallback: (adUnitId, error) {
                configLoaded = false;
              },
              onAdClickedCallback: (ad) {},
              onAdExpandedCallback: (ad) {},
              onAdCollapsedCallback: (ad) {},
            ),
          )
        : SizedBox(
            height: config.size.admobSize.height.toDouble(),
            width: config.size.admobSize.width.toDouble(),
            child: AdWidget(ad: ad.ad),
          );
  }
}
