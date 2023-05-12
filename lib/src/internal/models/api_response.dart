import 'dart:convert';

import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';

class AdSdkApiResponse {
  final String status;
  final String message;
  final AdSdkApp app;

  AdSdkApiResponse({
    required this.status,
    required this.message,
    required this.app,
  });

  factory AdSdkApiResponse.fromMap(Map<String, dynamic> map) {
    return AdSdkApiResponse(
      status: map['status'] ?? "",
      message: map['message'] ?? "",
      app: AdSdkApp.fromMap(map['app'] as Map<String, dynamic>),
    );
  }

  factory AdSdkApiResponse.fromJson(String source) =>
      AdSdkApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AdSdkApp {
  final bool showAppAds;
  final bool isActive;
  final String redirectLinkDescription;
  final String redirectLink;
  final bool enablePopup;
  final String id;
  final String appName;
  final String packageId;
  final String platform;
  final int latestVersion;
  final int criticalVersion;
  final String appUid;
  final List<AdSdkAdConfig> ads;
  final String createdAt;
  final String updatedAt;
  final int v;

  AdSdkApp({
    required this.showAppAds,
    required this.isActive,
    required this.redirectLinkDescription,
    required this.redirectLink,
    required this.enablePopup,
    required this.id,
    required this.appName,
    required this.packageId,
    required this.platform,
    required this.latestVersion,
    required this.criticalVersion,
    required this.appUid,
    required this.ads,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AdSdkApp.fromMap(Map<String, dynamic> map) {
    return AdSdkApp(
      showAppAds: map['showAppAds'] ?? false,
      isActive: map['isActive'] ?? false,
      redirectLinkDescription: map['redirectLinkDescription'] ?? "",
      redirectLink: map['redirectLink'] ?? "",
      enablePopup: map['enablePopup'] ?? false,
      id: map['_id'] ?? "",
      appName: map['appName'] ?? "",
      packageId: map['packageId'] ?? "",
      platform: map['platform'] ?? "",
      latestVersion: map['latestVersion'] ?? 0,
      criticalVersion: map['criticalVersion'] ?? 0,
      appUid: map['appUid'] ?? "",
      ads: List<AdSdkAdConfig>.from(
        (map['adMob'] ?? []).map<AdSdkAdConfig>(
          (x) => AdSdkAdConfig.fromMap(x),
        ),
      ),
      createdAt: map['createdAt'] ?? "",
      updatedAt: map['updatedAt'] ?? "",
      v: map['__v'] ?? 0,
    );
  }

  factory AdSdkApp.fromJson(String source) =>
      AdSdkApp.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AdSdkAdConfig {
  final List<String> primaryIds;
  final List<String> secondaryIds;
  final String id;
  final String adName;
  final AdProvider primaryAdprovider;
  final AdProvider secondaryAdprovider;
  final AdUnitType adType;
  final bool isActive;
  final int refreshRateMs;
  final String colorHex;
  final String colorHexDark;
  final String textColor;
  final String textColorDark;
  final String bgColor;
  final String bgColorDark;
  final AdSdkAdSize size;
  final int primaryAdloadTimeoutMs;
  final int backgroundThreshold;
  final int mediaHeight;

  AdSdkAdConfig({
    required this.primaryIds,
    required this.secondaryIds,
    required this.id,
    required this.adName,
    required this.primaryAdprovider,
    required this.secondaryAdprovider,
    required this.adType,
    required this.isActive,
    required this.refreshRateMs,
    required this.colorHex,
    required this.colorHexDark,
    required this.textColor,
    required this.textColorDark,
    required this.bgColor,
    required this.bgColorDark,
    required this.size,
    required this.primaryAdloadTimeoutMs,
    required this.backgroundThreshold,
    required this.mediaHeight,
  });

  factory AdSdkAdConfig.fromMap(Map<String, dynamic> map) {
    return AdSdkAdConfig(
      primaryIds: List<String>.from(map['primary_ids'] ?? []),
      secondaryIds: List<String>.from(map['secondary_ids'] ?? []),
      id: map['_id'] ?? "",
      adName: map['ad_name'] ?? "",
      primaryAdprovider:
          ((map['primary_adprovider'] ?? "") as String).adProvider,
      secondaryAdprovider:
          ((map['secondary_adprovider'] ?? "") as String).adProvider,
      adType: ((map['ad_type'] ?? "") as String).adUnitType,
      isActive: map['isActive'] ?? false,
      refreshRateMs: map['refresh_rate_ms'] ?? 0,
      colorHex: map['color_hex'] ?? "",
      colorHexDark: map['color_hex_dark'] ?? "",
      textColor: map['text_color'] ?? "",
      textColorDark: map['text_color_dark'] ?? "",
      bgColor: map['bg_color'] ?? "",
      bgColorDark: map['bg_color_dark'] ?? "",
      size: ((map['size'] ?? "") as String).adSdkAdSize,
      primaryAdloadTimeoutMs: map['primary_adload_timeout_ms'] ?? 0,
      backgroundThreshold: map['background_threshold'] ?? 0,
      mediaHeight: map['mediaHeight'] ?? 0,
    );
  }

  factory AdSdkAdConfig.fromJson(String source) =>
      AdSdkAdConfig.fromMap(json.decode(source) as Map<String, dynamic>);
}
