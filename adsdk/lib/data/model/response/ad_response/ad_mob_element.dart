import 'dart:ffi';
import 'dart:ui';

import 'package:adsdk/data/enums/ad_provider.dart';

class AdMobElement {
  List<String> primaryId;
  List<String> secondaryIds;
  String id;
  String adName;
  String adType;
  bool isActive;
  int refreshRateMs;
  Color colorHex;
  Color colorHexDark;
  Color bgColor;
  Color bgColorDark;
  Color textColor;
  Color textColorDark;
  Double size;
  int primaryAdLoadTimeoutMs;
  int backgroundThreshold;
  int mediaHeight;
  AdProvider primaryAdProvider;
  AdProvider secondaryAdProvider;

  AdMobElement({
    required this.primaryId,
    required this.secondaryIds,
    required this.id,
    required this.adName,
    required this.primaryAdProvider,
    required this.secondaryAdProvider,
    required this.adType,
    required this.isActive,
    required this.refreshRateMs,
    required this.colorHex,
    required this.colorHexDark,
    required this.bgColor,
    required this.bgColorDark,
    required this.textColor,
    required this.textColorDark,
    required this.size,
    required this.primaryAdLoadTimeoutMs,
    required this.backgroundThreshold,
    required this.mediaHeight,
  });

  factory AdMobElement.fromJson(Map<String, dynamic> json) => AdMobElement(
        primaryId: List<String>.from(json["primary_ids"].map((x) => x)),
        secondaryIds: List<String>.from(json["secondary_ids"].map((x) => x)),
        id: json["id"],
        adName: json["ad_name"],
        primaryAdProvider: adProviderValues.map[json["primary_adprovider"]]!,
        secondaryAdProvider:
            adProviderValues.map[json["secondary_adprovider"]]!,
        adType: json["ad_type"],
        isActive: json["isActive"],
        refreshRateMs: json["refresh_rate_ms"],
        colorHex: json["color_hex"],
        colorHexDark: json["color_hex_dark"],
        textColor: json["text_color"],
        textColorDark: json["text_color_dark"],
        bgColor: json["bg_color"],
        bgColorDark: json["bg_color_dark"],
        size: json["size"],
        primaryAdLoadTimeoutMs: json["primary_adload_timeout_ms"],
        backgroundThreshold: json["background_threshold"],
        mediaHeight: json["mediaHeight"],
      );
}

final adProviderValues = EnumValues({
  "Admanager": AdProvider.ADMANAGER,
  "Admob": AdProvider.ADMOB,
  "Applovin": AdProvider.APPLOVIN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
