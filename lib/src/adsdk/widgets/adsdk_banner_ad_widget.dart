import 'dart:developer';

import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSdkBannerAdWidget extends StatefulWidget {
  const AdSdkBannerAdWidget({super.key, required this.adSdkAdConfig});

  final AdSdkAdConfig adSdkAdConfig;

  @override
  State<AdSdkBannerAdWidget> createState() => _AdSdkBannerAdWidgetState();
}

class _AdSdkBannerAdWidgetState extends State<AdSdkBannerAdWidget> {
  late final AdSdkAdConfig config;
  bool adLoaded = false;

  late dynamic ad;
  late AdProvider adProvider;

  @override
  void initState() {
    config = widget.adSdkAdConfig;
    super.initState();
    if (config.primaryAdprovider == AdProvider.applovin) {
      adProvider = AdProvider.applovin;
      setState(() => adLoaded = true);
      return;
    }
    AdSdk.loadAd(
      adName: config.adName,
      adSdkBannerAdListener: AdSdkBannerAdListener(
        onAdFailedToLoad: (errors) {
          log(errors.toString());
        },
        onAdmobAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.admob;
          setState(() => adLoaded = true);
        },
        onAdmanagerAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.admanager;
          setState(() => adLoaded = true);
        },
        onApplovinAdLoaded: (ad) {
          this.ad = ad;
          adProvider = AdProvider.applovin;
          setState(() => adLoaded = true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!config.isActive || !adLoaded) return const SizedBox();
    if (adProvider == AdProvider.applovin) {
      return MaxAdView(
        adUnitId: config.primaryIds.first,
        adFormat: AdFormat.banner,
      );
    }
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: config.size.adSize.height.toDouble(),
            width: config.size.adSize.width.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ],
    );
  }
}
