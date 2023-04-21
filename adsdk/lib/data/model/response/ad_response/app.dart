import 'package:adsdk/data/model/response/ad_response/ad_mob.dart';

class App {
  bool showAppAds;
  bool isActive;
  String? id;
  String? appName;
  String? packageId;
  String? platform;
  int? latestVersion;
  int? criticalVersion;
  String? appUid;
  List<AdMob>? adMob;

  App(
      {this.showAppAds = true,
      this.isActive = true,
      this.id,
      this.appName,
      this.packageId,
      this.platform,
      this.latestVersion,
      this.criticalVersion,
      this.appUid,
      this.adMob});

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
      adMob: List<AdMob>.from(json["adMob"].map((x) => AdMob.fromJson(x))));
}
