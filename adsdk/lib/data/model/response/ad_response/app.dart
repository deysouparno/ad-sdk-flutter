import 'package:adsdk/data/model/response/ad_response/ad_mob_element.dart';

class App {
  bool showAppAds;
  bool isActive;
  String id;
  String appName;
  String packageId;
  String platform;
  int latestVersion;
  int criticalVersion;
  String appUid;
  List<AdMobElement> adMob;

  App(
      {this.showAppAds = true,
      this.isActive = true,
      required this.id,
      required this.appName,
      required this.packageId,
      required this.platform,
      required this.latestVersion,
      required this.criticalVersion,
      required this.appUid,
      required this.adMob});

  factory App.fromJson(Map<String, dynamic> json) => App(
      showAppAds: json["showAppAds"],
      isActive: json["isActive"],
      id: json["id"],
      appName: json["appName"],
      packageId: json["packageId"],
      platform: json["platform"],
      latestVersion: json["latestVersion"],
      criticalVersion: json["criticalVersion"],
      appUid: json["appUid"],
      adMob: List<AdMobElement>.from(
          json["adMob"].map((x) => AdMobElement.fromJson(x))));
}
