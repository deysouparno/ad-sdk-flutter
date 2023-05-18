import 'dart:async';
import 'dart:developer';

import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSdkBannerAdWidget extends StatefulWidget {
  const AdSdkBannerAdWidget({super.key, required this.adName});

  final String adName;

  @override
  State<AdSdkBannerAdWidget> createState() => _AdSdkBannerAdWidgetState();
}

class _AdSdkBannerAdWidgetState extends State<AdSdkBannerAdWidget> {
  late final AdSdkAdConfig config;
  bool adLoaded = false;

  late AdSdkAd ad;
  late AdProvider adProvider;
  Timer? _timer;

  @override
  void initState() {
    final ad = AdSdkState.ads[widget.adName];
    if (ad == null) {
      AdSdkLogger.error("Please provided correct adName.");
      return;
    }
    config = ad;
    AdSdkLogger.info(
      "Ad size of '${config.adName} - (${config.size.admobSize.height}, ${config.size.admobSize.width})'",
    );
    super.initState();
    if (config.primaryAdprovider == AdProvider.applovin) {
      adProvider = AdProvider.applovin;
      setState(() => adLoaded = true);
      return;
    }
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
          (_) => loadAd(),
        );
      },
    );
  }

  void loadAd() {
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
        Future.delayed(
             Duration(seconds: AdSdkState.adSdkConfig.isTestMode ?  1 : 0), () => setState(() => adLoaded = true));
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!config.isActive || !adLoaded) return const SizedBox();
    return adProvider == AdProvider.applovin
        ? MaxAdView(
            adUnitId: config.primaryIds.first,
            adFormat: config.size.applovinSize,
          )
        : SizedBox(
            height: config.size.admobSize.height.toDouble(),
            width: config.size.admobSize.width.toDouble(),
            child: AdWidget(ad: ad.ad),
          );
  }
}
