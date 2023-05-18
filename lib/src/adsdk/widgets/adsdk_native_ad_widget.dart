import 'dart:async';

import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSdkNativeAdWidget extends StatefulWidget {
  const AdSdkNativeAdWidget(
      {super.key, required this.adName, this.isDarkMode = false});

  final String adName;
  final bool isDarkMode;

  @override
  State<AdSdkNativeAdWidget> createState() => _AdSdkNativeAdWidgetState();
}

class _AdSdkNativeAdWidgetState extends State<AdSdkNativeAdWidget> {
  late final AdSdkAdConfig config;
  bool adLoaded = false;

  late NativeAd ad;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final ad = AdSdkState.ads[widget.adName];
    if (ad == null) {
      AdSdkLogger.error("Please provided correct adName.");
      return;
    }
    config = ad;
    AdSdk.loadAd(
      adName: config.adName,
      isDarkMode: widget.isDarkMode,
      onAdFailedToLoad: (errors) {
        AdSdkLogger.error(
          "Failed to load ad - '${config.adName}' with errors - $errors",
        );
        setState(() => adLoaded = false);
      },
      onAdLoaded: (ad) {
        AdSdkLogger.info("Here: ${ad.toString()}");
        setState(() => adLoaded = false);
        setState(() {
          this.ad = ad.ad;
          adLoaded = true;
        });
        _timer = Timer.periodic(
            Duration(milliseconds: config.refreshRateMs), (_) => loadAd());
      },
    );
  }

  void loadAd() {
    AdSdk.loadAd(
      adName: config.adName,
      isDarkMode: widget.isDarkMode,
      onAdFailedToLoad: (errors) {
        AdSdkLogger.error(
          "Failed to load ad - '${config.adName}' with errors - $errors",
        );
        setState(() => adLoaded = false);
      },
      onAdLoaded: (ad) {
        AdSdkLogger.info("Here: ${ad.toString()}");
        setState(() => adLoaded = false);
        Future.delayed(
          Duration(seconds: AdSdkState.adSdkConfig.isTestMode ? 1 : 0),
          () => setState(() {
            this.ad = ad.ad;
            adLoaded = true;
          }),
        );
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
    return Container(
      height: config.mediaHeight.toDouble(),
      decoration: BoxDecoration(
        color: Color(
          int.parse(
            widget.isDarkMode
                ? config.bgColorDark.replaceFirst("#", "0xFF")
                : config.bgColor.replaceFirst("#", "0xFF"),
          ),
        ),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: AdWidget(ad: ad),
    );
  }
}
