class AdMob {
  List<String>? primaryId;
  List<String>? secondaryIds;
  String? id;
  String? adName;
  String? adType;
  bool? isActive;
  int? refreshRateMs;
  String? colorHex;
  String? colorHexDark;
  String? bgColor;
  String? bgColorDark;
  String? textColor;
  String? textColorDark;
  String? size;
  int? primaryAdLoadTimeoutMs;
  int? backgroundThreshold;
  int? mediaHeight;
  String? primaryAdProvider;
  String? secondaryAdProvider;

  AdMob({
    this.primaryId,
    this.secondaryIds,
    this.id,
    this.adName,
    this.primaryAdProvider,
    this.secondaryAdProvider,
    this.adType,
    this.isActive,
    this.refreshRateMs,
    this.colorHex,
    this.colorHexDark,
    this.bgColor,
    this.bgColorDark,
    this.textColor,
    this.textColorDark,
    this.size,
    this.primaryAdLoadTimeoutMs,
    this.backgroundThreshold,
    this.mediaHeight,
  });

  factory AdMob.fromJson(Map<String, dynamic> json) => AdMob(
        primaryId: List<String>.from(json["primary_ids"].map((x) => x)),
        secondaryIds: List<String>.from(json["secondary_ids"].map((x) => x)),
        id: json["id"],
        adName: json["ad_name"],
        primaryAdProvider: json["primary_adprovider"],
        secondaryAdProvider: json["secondary_adprovider"],
        adType: json["ad_type"],
        isActive: json["isActive"],
        refreshRateMs: json["refresh_rate_ms"],
        colorHex: json["color_hex"],
        colorHexDark: json["color_hex_dark"],
        textColor: json["text_color"],
        textColorDark: json["text_color_dark"],
        bgColor: json["bg_color"]!,
        bgColorDark: json["bg_color_dark"],
        size: json["size"],
        primaryAdLoadTimeoutMs: json["primary_adload_timeout_ms"],
        backgroundThreshold: json["background_threshold"],
        mediaHeight: json["mediaHeight"],
      );
}
