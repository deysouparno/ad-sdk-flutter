import 'dart:async';

import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/adsdk_state.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/internal/models/api_response.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class AdSdkNativeAdWidget extends StatefulWidget {
  const AdSdkNativeAdWidget({
    super.key,
    required this.adName,
    this.isDarkMode = false,
    this.adSdkAd,
  });

  final String adName;
  final AdSdkAd? adSdkAd;
  final bool isDarkMode;

  @override
  State<AdSdkNativeAdWidget> createState() => _AdSdkNativeAdWidgetState();
}

class _AdSdkNativeAdWidgetState extends State<AdSdkNativeAdWidget> {
  AdSdkAdConfig? config;
  bool adLoaded = false;

  NativeAd? ad;
  NativeAd? newAd;
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
      setState(() => config = ad);
      if (widget.adSdkAd != null) {
        setState(() {
          this.ad = widget.adSdkAd!.ad;
          adLoaded = true;
        });
        startAutoRefresh();
      } else {
        if (config == null) {
          AdSdk.loadAd(
            adName: config!.adName,
            isDarkMode: widget.isDarkMode,
            onAdFailedToLoad: (errors) {
              AdSdkLogger.error(
                "Failed to load ad - '${config!.adName}' with errors - $errors",
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
              loadAd();
              startAutoRefresh();
            },
          );
        }
      }
    });
  }

  void startAutoRefresh() {
    if (config == null) return;
    AdSdkLogger.info("Starting auto refresh for ad: ${config!.adName}");
    _timer = Timer.periodic(
      Duration(milliseconds: config!.refreshRateMs),
      (_) {
        if (newAd != null) {
          setState(() => adLoaded = false);
          Future.delayed(
            Duration(seconds: AdSdkState.adSdkConfig.isTestMode ? 1 : 0),
            () {
              setState(() => ad = newAd!);
              setState(() => adLoaded = true);
            },
          );
        }
        loadAd();
      },
    );
  }

  void loadAd() {
    if (config == null) return;
    AdSdk.loadAd(
      adName: config!.adName,
      isDarkMode: widget.isDarkMode,
      onAdFailedToLoad: (errors) {
        AdSdkLogger.error(
          "Failed to load ad - '${config!.adName}' with errors - $errors",
        );
      },
      onAdLoaded: (ad) {
        AdSdkLogger.info("New Ad Loaded: ${ad.toString()}");
        setState(() => newAd = ad.ad);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.adSdkAd?.dispose();
    ad?.dispose();
    newAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (config == null || ad == null) return const SizedBox();
    if (!config!.isActive) return const SizedBox();
    if (!adLoaded) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.grey.withOpacity(0.6),
        period: const Duration(seconds: 1),
        child: Container(
          height: config!.size.nativeAdHeight,
          width: double.maxFinite,
          decoration: const BoxDecoration(color: Colors.grey),
        ),
      );
    }
    return Container(
      height: config!.size.nativeAdHeight,
      decoration: BoxDecoration(
        color: Color(
          int.parse(
            widget.isDarkMode
                ? config!.bgColorDark.replaceFirst("#", "0xFF")
                : config!.bgColor.replaceFirst("#", "0xFF"),
          ),
        ),
      ),
      child: AdWidget(ad: ad!),
    );
  }
}
